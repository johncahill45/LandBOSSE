WITH left_CTE AS (
SELECT
	"Project ID with serial" AS left_id,
	"Turbine rating MW_x" AS left_turbine_rating_MW,
	"Number of turbines_x" AS left_number_of_turbines,
	"Hub height m" AS left_hub_height_m,
	"Labor cost multiplier" AS left_lcm,
	"Crane breakdown fraction" AS left_cbf,
	ROUND("Turbine rating MW_x" * "Number of turbines_x") AS left_project_size_MW,
 	ROUND(SUM("USD/kW per project")) AS left_project_usd_kW
FROM
	costs_with_extended_project_list
WHERE
	"Crane breakdown fraction" = 0
GROUP BY
	1, 2, 3, 4, 5, 6
ORDER BY
	"Project ID with serial"
),

right_CTE AS (
SELECT
	"Project ID with serial" AS right_id,
	"Turbine rating MW_x" as right_turbine_rating_MW,
	"Number of turbines_x" AS right_number_of_turbines,
	"Hub height m" AS right_hub_height_m,
	"Labor cost multiplier" AS right_lcm,
	"Crane breakdown fraction" AS right_cbf,
	ROUND("Turbine rating MW_x" * "Number of turbines_x") AS right_project_size_MW,
	ROUND(SUM("USD/kW per project")) AS right_project_usd_kW
FROM
	costs_with_extended_project_list
WHERE
	"Crane breakdown fraction" = 1
GROUP BY
	1, 2, 3, 4, 5, 6
ORDER BY
	"Project ID with serial"
)

SELECT
	left_id,
	left_turbine_rating_MW,
	left_number_of_turbines,
	left_hub_height_m,
	left_lcm,
	left_cbf,
	left_project_size_MW,
	left_project_usd_kW,
	right_id,
	right_turbine_rating_MW,
	right_number_of_turbines,
	right_hub_height_m,
	right_lcm,
	right_cbf,
	right_project_size_MW,
	right_project_usd_kW,
 	right_project_usd_kW / left_project_usd_kW AS delta_project_usd_kW
FROM 
	left_CTE
JOIN right_CTE
	ON left_turbine_rating_MW = right_turbine_rating_MW
	AND left_number_of_turbines = right_number_of_turbines
	AND left_hub_height_m = right_hub_height_m
	AND left_lcm = right_lcm
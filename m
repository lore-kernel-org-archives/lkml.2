Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758136Ab2K3MDZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 07:03:25 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:55975 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755013Ab2K3MDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 07:03:21 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linus.walleij@stericsson.com, arnd@arndb.de, cbou@mail.ru,
        dwmw2@infradead.org, rajanikanth.hv@linaro.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 04/12] ab8500_btemp: Fix crazy tabbing implementation
Date: Fri, 30 Nov 2012 11:57:26 +0000
Message-Id: <1354276654-590-5-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1354276654-590-1-git-send-email-lee.jones@linaro.org>
References: <1354276654-590-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simple patch to rectify incorrect tabbing. Also adds some
coding style clean-ups to make it easier to read.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/power/ab8500_bmdata.c |  457 +++++++++++++++++++++--------------------
 1 file changed, 229 insertions(+), 228 deletions(-)

diff --git a/drivers/power/ab8500_bmdata.c b/drivers/power/ab8500_bmdata.c
index f16b60c..2623b16 100644
--- a/drivers/power/ab8500_bmdata.c
+++ b/drivers/power/ab8500_bmdata.c
@@ -182,206 +182,206 @@ static struct batres_vs_temp temp_to_batres_tbl_9100[] = {
 };
 
 static struct abx500_battery_type bat_type_thermistor[] = {
-[BATTERY_UNKNOWN] = {
-	/* First element always represent the UNKNOWN battery */
-	.name = POWER_SUPPLY_TECHNOLOGY_UNKNOWN,
-	.resis_high = 0,
-	.resis_low = 0,
-	.battery_resistance = 300,
-	.charge_full_design = 612,
-	.nominal_voltage = 3700,
-	.termination_vol = 4050,
-	.termination_curr = 200,
-	.recharge_vol = 3990,
-	.normal_cur_lvl = 400,
-	.normal_vol_lvl = 4100,
-	.maint_a_cur_lvl = 400,
-	.maint_a_vol_lvl = 4050,
-	.maint_a_chg_timer_h = 60,
-	.maint_b_cur_lvl = 400,
-	.maint_b_vol_lvl = 4000,
-	.maint_b_chg_timer_h = 200,
-	.low_high_cur_lvl = 300,
-	.low_high_vol_lvl = 4000,
-	.n_temp_tbl_elements = ARRAY_SIZE(temp_tbl),
-	.r_to_t_tbl = temp_tbl,
-	.n_v_cap_tbl_elements = ARRAY_SIZE(cap_tbl),
-	.v_to_cap_tbl = cap_tbl,
-	.n_batres_tbl_elements = ARRAY_SIZE(temp_to_batres_tbl_thermistor),
-	.batres_tbl = temp_to_batres_tbl_thermistor,
-},
-{
-	.name = POWER_SUPPLY_TECHNOLOGY_LIPO,
-	.resis_high = 53407,
-	.resis_low = 12500,
-	.battery_resistance = 300,
-	.charge_full_design = 900,
-	.nominal_voltage = 3600,
-	.termination_vol = 4150,
-	.termination_curr = 80,
-	.recharge_vol = 4130,
-	.normal_cur_lvl = 700,
-	.normal_vol_lvl = 4200,
-	.maint_a_cur_lvl = 600,
-	.maint_a_vol_lvl = 4150,
-	.maint_a_chg_timer_h = 60,
-	.maint_b_cur_lvl = 600,
-	.maint_b_vol_lvl = 4100,
-	.maint_b_chg_timer_h = 200,
-	.low_high_cur_lvl = 300,
-	.low_high_vol_lvl = 4000,
-	.n_temp_tbl_elements = ARRAY_SIZE(temp_tbl_A_thermistor),
-	.r_to_t_tbl = temp_tbl_A_thermistor,
-	.n_v_cap_tbl_elements = ARRAY_SIZE(cap_tbl_A_thermistor),
-	.v_to_cap_tbl = cap_tbl_A_thermistor,
-	.n_batres_tbl_elements = ARRAY_SIZE(temp_to_batres_tbl_thermistor),
-	.batres_tbl = temp_to_batres_tbl_thermistor,
+	[BATTERY_UNKNOWN] = {
+		/* First element always represent the UNKNOWN battery */
+		.name = POWER_SUPPLY_TECHNOLOGY_UNKNOWN,
+		.resis_high = 0,
+		.resis_low = 0,
+		.battery_resistance = 300,
+		.charge_full_design = 612,
+		.nominal_voltage = 3700,
+		.termination_vol = 4050,
+		.termination_curr = 200,
+		.recharge_vol = 3990,
+		.normal_cur_lvl = 400,
+		.normal_vol_lvl = 4100,
+		.maint_a_cur_lvl = 400,
+		.maint_a_vol_lvl = 4050,
+		.maint_a_chg_timer_h = 60,
+		.maint_b_cur_lvl = 400,
+		.maint_b_vol_lvl = 4000,
+		.maint_b_chg_timer_h = 200,
+		.low_high_cur_lvl = 300,
+		.low_high_vol_lvl = 4000,
+		.n_temp_tbl_elements = ARRAY_SIZE(temp_tbl),
+		.r_to_t_tbl = temp_tbl,
+		.n_v_cap_tbl_elements = ARRAY_SIZE(cap_tbl),
+		.v_to_cap_tbl = cap_tbl,
+		.n_batres_tbl_elements = ARRAY_SIZE(temp_to_batres_tbl_thermistor),
+		.batres_tbl = temp_to_batres_tbl_thermistor,
+	},
+	{
+		.name = POWER_SUPPLY_TECHNOLOGY_LIPO,
+		.resis_high = 53407,
+		.resis_low = 12500,
+		.battery_resistance = 300,
+		.charge_full_design = 900,
+		.nominal_voltage = 3600,
+		.termination_vol = 4150,
+		.termination_curr = 80,
+		.recharge_vol = 4130,
+		.normal_cur_lvl = 700,
+		.normal_vol_lvl = 4200,
+		.maint_a_cur_lvl = 600,
+		.maint_a_vol_lvl = 4150,
+		.maint_a_chg_timer_h = 60,
+		.maint_b_cur_lvl = 600,
+		.maint_b_vol_lvl = 4100,
+		.maint_b_chg_timer_h = 200,
+		.low_high_cur_lvl = 300,
+		.low_high_vol_lvl = 4000,
+		.n_temp_tbl_elements = ARRAY_SIZE(temp_tbl_A_thermistor),
+		.r_to_t_tbl = temp_tbl_A_thermistor,
+		.n_v_cap_tbl_elements = ARRAY_SIZE(cap_tbl_A_thermistor),
+		.v_to_cap_tbl = cap_tbl_A_thermistor,
+		.n_batres_tbl_elements = ARRAY_SIZE(temp_to_batres_tbl_thermistor),
+		.batres_tbl = temp_to_batres_tbl_thermistor,
 
-},
-{
-	.name = POWER_SUPPLY_TECHNOLOGY_LIPO,
-	.resis_high = 200000,
-	.resis_low = 82869,
-	.battery_resistance = 300,
-	.charge_full_design = 900,
-	.nominal_voltage = 3600,
-	.termination_vol = 4150,
-	.termination_curr = 80,
-	.recharge_vol = 4130,
-	.normal_cur_lvl = 700,
-	.normal_vol_lvl = 4200,
-	.maint_a_cur_lvl = 600,
-	.maint_a_vol_lvl = 4150,
-	.maint_a_chg_timer_h = 60,
-	.maint_b_cur_lvl = 600,
-	.maint_b_vol_lvl = 4100,
-	.maint_b_chg_timer_h = 200,
-	.low_high_cur_lvl = 300,
-	.low_high_vol_lvl = 4000,
-	.n_temp_tbl_elements = ARRAY_SIZE(temp_tbl_B_thermistor),
-	.r_to_t_tbl = temp_tbl_B_thermistor,
-	.n_v_cap_tbl_elements = ARRAY_SIZE(cap_tbl_B_thermistor),
-	.v_to_cap_tbl = cap_tbl_B_thermistor,
-	.n_batres_tbl_elements = ARRAY_SIZE(temp_to_batres_tbl_thermistor),
-	.batres_tbl = temp_to_batres_tbl_thermistor,
-},
+	},
+	{
+		.name = POWER_SUPPLY_TECHNOLOGY_LIPO,
+		.resis_high = 200000,
+		.resis_low = 82869,
+		.battery_resistance = 300,
+		.charge_full_design = 900,
+		.nominal_voltage = 3600,
+		.termination_vol = 4150,
+		.termination_curr = 80,
+		.recharge_vol = 4130,
+		.normal_cur_lvl = 700,
+		.normal_vol_lvl = 4200,
+		.maint_a_cur_lvl = 600,
+		.maint_a_vol_lvl = 4150,
+		.maint_a_chg_timer_h = 60,
+		.maint_b_cur_lvl = 600,
+		.maint_b_vol_lvl = 4100,
+		.maint_b_chg_timer_h = 200,
+		.low_high_cur_lvl = 300,
+		.low_high_vol_lvl = 4000,
+		.n_temp_tbl_elements = ARRAY_SIZE(temp_tbl_B_thermistor),
+		.r_to_t_tbl = temp_tbl_B_thermistor,
+		.n_v_cap_tbl_elements = ARRAY_SIZE(cap_tbl_B_thermistor),
+		.v_to_cap_tbl = cap_tbl_B_thermistor,
+		.n_batres_tbl_elements = ARRAY_SIZE(temp_to_batres_tbl_thermistor),
+		.batres_tbl = temp_to_batres_tbl_thermistor,
+	},
 };
 
 static struct abx500_battery_type bat_type_ext_thermistor[] = {
-[BATTERY_UNKNOWN] = {
-	/* First element always represent the UNKNOWN battery */
-	.name = POWER_SUPPLY_TECHNOLOGY_UNKNOWN,
-	.resis_high = 0,
-	.resis_low = 0,
-	.battery_resistance = 300,
-	.charge_full_design = 612,
-	.nominal_voltage = 3700,
-	.termination_vol = 4050,
-	.termination_curr = 200,
-	.recharge_vol = 3990,
-	.normal_cur_lvl = 400,
-	.normal_vol_lvl = 4100,
-	.maint_a_cur_lvl = 400,
-	.maint_a_vol_lvl = 4050,
-	.maint_a_chg_timer_h = 60,
-	.maint_b_cur_lvl = 400,
-	.maint_b_vol_lvl = 4000,
-	.maint_b_chg_timer_h = 200,
-	.low_high_cur_lvl = 300,
-	.low_high_vol_lvl = 4000,
-	.n_temp_tbl_elements = ARRAY_SIZE(temp_tbl),
-	.r_to_t_tbl = temp_tbl,
-	.n_v_cap_tbl_elements = ARRAY_SIZE(cap_tbl),
-	.v_to_cap_tbl = cap_tbl,
-	.n_batres_tbl_elements = ARRAY_SIZE(temp_to_batres_tbl_thermistor),
-	.batres_tbl = temp_to_batres_tbl_thermistor,
-},
+	[BATTERY_UNKNOWN] = {
+		/* First element always represent the UNKNOWN battery */
+		.name = POWER_SUPPLY_TECHNOLOGY_UNKNOWN,
+		.resis_high = 0,
+		.resis_low = 0,
+		.battery_resistance = 300,
+		.charge_full_design = 612,
+		.nominal_voltage = 3700,
+		.termination_vol = 4050,
+		.termination_curr = 200,
+		.recharge_vol = 3990,
+		.normal_cur_lvl = 400,
+		.normal_vol_lvl = 4100,
+		.maint_a_cur_lvl = 400,
+		.maint_a_vol_lvl = 4050,
+		.maint_a_chg_timer_h = 60,
+		.maint_b_cur_lvl = 400,
+		.maint_b_vol_lvl = 4000,
+		.maint_b_chg_timer_h = 200,
+		.low_high_cur_lvl = 300,
+		.low_high_vol_lvl = 4000,
+		.n_temp_tbl_elements = ARRAY_SIZE(temp_tbl),
+		.r_to_t_tbl = temp_tbl,
+		.n_v_cap_tbl_elements = ARRAY_SIZE(cap_tbl),
+		.v_to_cap_tbl = cap_tbl,
+		.n_batres_tbl_elements = ARRAY_SIZE(temp_to_batres_tbl_thermistor),
+		.batres_tbl = temp_to_batres_tbl_thermistor,
+	},
 /*
  * These are the batteries that doesn't have an internal NTC resistor to measure
  * its temperature. The temperature in this case is measure with a NTC placed
  * near the battery but on the PCB.
  */
-{
-	.name = POWER_SUPPLY_TECHNOLOGY_LIPO,
-	.resis_high = 76000,
-	.resis_low = 53000,
-	.battery_resistance = 300,
-	.charge_full_design = 900,
-	.nominal_voltage = 3700,
-	.termination_vol = 4150,
-	.termination_curr = 100,
-	.recharge_vol = 4130,
-	.normal_cur_lvl = 700,
-	.normal_vol_lvl = 4200,
-	.maint_a_cur_lvl = 600,
-	.maint_a_vol_lvl = 4150,
-	.maint_a_chg_timer_h = 60,
-	.maint_b_cur_lvl = 600,
-	.maint_b_vol_lvl = 4100,
-	.maint_b_chg_timer_h = 200,
-	.low_high_cur_lvl = 300,
-	.low_high_vol_lvl = 4000,
-	.n_temp_tbl_elements = ARRAY_SIZE(temp_tbl),
-	.r_to_t_tbl = temp_tbl,
-	.n_v_cap_tbl_elements = ARRAY_SIZE(cap_tbl),
-	.v_to_cap_tbl = cap_tbl,
-	.n_batres_tbl_elements = ARRAY_SIZE(temp_to_batres_tbl_thermistor),
-	.batres_tbl = temp_to_batres_tbl_thermistor,
-},
-{
-	.name = POWER_SUPPLY_TECHNOLOGY_LION,
-	.resis_high = 30000,
-	.resis_low = 10000,
-	.battery_resistance = 300,
-	.charge_full_design = 950,
-	.nominal_voltage = 3700,
-	.termination_vol = 4150,
-	.termination_curr = 100,
-	.recharge_vol = 4130,
-	.normal_cur_lvl = 700,
-	.normal_vol_lvl = 4200,
-	.maint_a_cur_lvl = 600,
-	.maint_a_vol_lvl = 4150,
-	.maint_a_chg_timer_h = 60,
-	.maint_b_cur_lvl = 600,
-	.maint_b_vol_lvl = 4100,
-	.maint_b_chg_timer_h = 200,
-	.low_high_cur_lvl = 300,
-	.low_high_vol_lvl = 4000,
-	.n_temp_tbl_elements = ARRAY_SIZE(temp_tbl),
-	.r_to_t_tbl = temp_tbl,
-	.n_v_cap_tbl_elements = ARRAY_SIZE(cap_tbl),
-	.v_to_cap_tbl = cap_tbl,
-	.n_batres_tbl_elements = ARRAY_SIZE(temp_to_batres_tbl_thermistor),
-	.batres_tbl = temp_to_batres_tbl_thermistor,
-},
-{
-	.name = POWER_SUPPLY_TECHNOLOGY_LION,
-	.resis_high = 95000,
-	.resis_low = 76001,
-	.battery_resistance = 300,
-	.charge_full_design = 950,
-	.nominal_voltage = 3700,
-	.termination_vol = 4150,
-	.termination_curr = 100,
-	.recharge_vol = 4130,
-	.normal_cur_lvl = 700,
-	.normal_vol_lvl = 4200,
-	.maint_a_cur_lvl = 600,
-	.maint_a_vol_lvl = 4150,
-	.maint_a_chg_timer_h = 60,
-	.maint_b_cur_lvl = 600,
-	.maint_b_vol_lvl = 4100,
-	.maint_b_chg_timer_h = 200,
-	.low_high_cur_lvl = 300,
-	.low_high_vol_lvl = 4000,
-	.n_temp_tbl_elements = ARRAY_SIZE(temp_tbl),
-	.r_to_t_tbl = temp_tbl,
-	.n_v_cap_tbl_elements = ARRAY_SIZE(cap_tbl),
-	.v_to_cap_tbl = cap_tbl,
-	.n_batres_tbl_elements = ARRAY_SIZE(temp_to_batres_tbl_thermistor),
-	.batres_tbl = temp_to_batres_tbl_thermistor,
-},
+	{
+		.name = POWER_SUPPLY_TECHNOLOGY_LIPO,
+		.resis_high = 76000,
+		.resis_low = 53000,
+		.battery_resistance = 300,
+		.charge_full_design = 900,
+		.nominal_voltage = 3700,
+		.termination_vol = 4150,
+		.termination_curr = 100,
+		.recharge_vol = 4130,
+		.normal_cur_lvl = 700,
+		.normal_vol_lvl = 4200,
+		.maint_a_cur_lvl = 600,
+		.maint_a_vol_lvl = 4150,
+		.maint_a_chg_timer_h = 60,
+		.maint_b_cur_lvl = 600,
+		.maint_b_vol_lvl = 4100,
+		.maint_b_chg_timer_h = 200,
+		.low_high_cur_lvl = 300,
+		.low_high_vol_lvl = 4000,
+		.n_temp_tbl_elements = ARRAY_SIZE(temp_tbl),
+		.r_to_t_tbl = temp_tbl,
+		.n_v_cap_tbl_elements = ARRAY_SIZE(cap_tbl),
+		.v_to_cap_tbl = cap_tbl,
+		.n_batres_tbl_elements = ARRAY_SIZE(temp_to_batres_tbl_thermistor),
+		.batres_tbl = temp_to_batres_tbl_thermistor,
+	},
+	{
+		.name = POWER_SUPPLY_TECHNOLOGY_LION,
+		.resis_high = 30000,
+		.resis_low = 10000,
+		.battery_resistance = 300,
+		.charge_full_design = 950,
+		.nominal_voltage = 3700,
+		.termination_vol = 4150,
+		.termination_curr = 100,
+		.recharge_vol = 4130,
+		.normal_cur_lvl = 700,
+		.normal_vol_lvl = 4200,
+		.maint_a_cur_lvl = 600,
+		.maint_a_vol_lvl = 4150,
+		.maint_a_chg_timer_h = 60,
+		.maint_b_cur_lvl = 600,
+		.maint_b_vol_lvl = 4100,
+		.maint_b_chg_timer_h = 200,
+		.low_high_cur_lvl = 300,
+		.low_high_vol_lvl = 4000,
+		.n_temp_tbl_elements = ARRAY_SIZE(temp_tbl),
+		.r_to_t_tbl = temp_tbl,
+		.n_v_cap_tbl_elements = ARRAY_SIZE(cap_tbl),
+		.v_to_cap_tbl = cap_tbl,
+		.n_batres_tbl_elements = ARRAY_SIZE(temp_to_batres_tbl_thermistor),
+		.batres_tbl = temp_to_batres_tbl_thermistor,
+	},
+	{
+		.name = POWER_SUPPLY_TECHNOLOGY_LION,
+		.resis_high = 95000,
+		.resis_low = 76001,
+		.battery_resistance = 300,
+		.charge_full_design = 950,
+		.nominal_voltage = 3700,
+		.termination_vol = 4150,
+		.termination_curr = 100,
+		.recharge_vol = 4130,
+		.normal_cur_lvl = 700,
+		.normal_vol_lvl = 4200,
+		.maint_a_cur_lvl = 600,
+		.maint_a_vol_lvl = 4150,
+		.maint_a_chg_timer_h = 60,
+		.maint_b_cur_lvl = 600,
+		.maint_b_vol_lvl = 4100,
+		.maint_b_chg_timer_h = 200,
+		.low_high_cur_lvl = 300,
+		.low_high_vol_lvl = 4000,
+		.n_temp_tbl_elements = ARRAY_SIZE(temp_tbl),
+		.r_to_t_tbl = temp_tbl,
+		.n_v_cap_tbl_elements = ARRAY_SIZE(cap_tbl),
+		.v_to_cap_tbl = cap_tbl,
+		.n_batres_tbl_elements = ARRAY_SIZE(temp_to_batres_tbl_thermistor),
+		.batres_tbl = temp_to_batres_tbl_thermistor,
+	},
 };
 
 static const struct abx500_bm_capacity_levels cap_levels = {
@@ -424,42 +424,41 @@ static const struct abx500_bm_charger_parameters chg = {
 };
 
 struct abx500_bm_data ab8500_bm_data = {
-	.temp_under		= 3,
-	.temp_low		= 8,
-	.temp_high		= 43,
-	.temp_over		= 48,
-	.main_safety_tmr_h	= 4,
-	.temp_interval_chg	= 20,
-	.temp_interval_nochg	= 120,
-	.usb_safety_tmr_h	= 4,
-	.bkup_bat_v		= BUP_VCH_SEL_2P6V,
-	.bkup_bat_i		= BUP_ICH_SEL_150UA,
-	.no_maintenance		= false,
-	.adc_therm		= ABx500_ADC_THERM_BATCTRL,
-	.chg_unknown_bat	= false,
-	.enable_overshoot	= false,
-	.fg_res			= 100,
-	.cap_levels		= &cap_levels,
-	.bat_type		= bat_type_thermistor,
-	.n_btypes		= 3,
-	.batt_id		= 0,
-	.interval_charging	= 5,
-	.interval_not_charging	= 120,
-	.temp_hysteresis	= 3,
-	.gnd_lift_resistance	= 34,
-	.maxi			= &maxi_params,
-	.chg_params		= &chg,
-	.fg_params		= &fg,
+	.temp_under             = 3,
+	.temp_low               = 8,
+	.temp_high              = 43,
+	.temp_over              = 48,
+	.main_safety_tmr_h      = 4,
+	.temp_interval_chg      = 20,
+	.temp_interval_nochg    = 120,
+	.usb_safety_tmr_h       = 4,
+	.bkup_bat_v             = BUP_VCH_SEL_2P6V,
+	.bkup_bat_i             = BUP_ICH_SEL_150UA,
+	.no_maintenance         = false,
+	.adc_therm              = ABx500_ADC_THERM_BATCTRL,
+	.chg_unknown_bat        = false,
+	.enable_overshoot       = false,
+	.fg_res                 = 100,
+	.cap_levels             = &cap_levels,
+	.bat_type               = bat_type_thermistor,
+	.n_btypes               = 3,
+	.batt_id                = 0,
+	.interval_charging      = 5,
+	.interval_not_charging  = 120,
+	.temp_hysteresis        = 3,
+	.gnd_lift_resistance    = 34,
+	.maxi                   = &maxi_params,
+	.chg_params             = &chg,
+	.fg_params              = &fg,
 };
 
-int __devinit
-bmdevs_of_probe(struct device *dev,
-		struct device_node *np,
-		struct abx500_bm_data **battery)
+int __devinit bmdevs_of_probe(struct device *dev,
+			      struct device_node *np,
+			      struct abx500_bm_data **battery)
 {
-	struct	abx500_battery_type *btype;
-	struct  device_node *np_bat_supply;
-	struct	abx500_bm_data *bat;
+	struct abx500_battery_type *btype;
+	struct device_node *np_bat_supply;
+	struct abx500_bm_data *bat;
 	const char *btech;
 	int i, thermistor;
 
@@ -471,8 +470,8 @@ bmdevs_of_probe(struct device *dev,
 		dev_err(dev, "missing property battery\n");
 		return -EINVAL;
 	}
-	if (of_property_read_bool(np_bat_supply,
-			"thermistor-on-batctrl"))
+
+	if (of_property_read_bool(np_bat_supply, "thermistor-on-batctrl"))
 		thermistor = NTC_INTERNAL;
 	else
 		thermistor = NTC_EXTERNAL;
@@ -483,8 +482,8 @@ bmdevs_of_probe(struct device *dev,
 		bat->bat_type  = bat_type_ext_thermistor;
 		bat->adc_therm = ABx500_ADC_THERM_BATTEMP;
 	}
-	btech = of_get_property(np_bat_supply,
-		"stericsson,battery-type", NULL);
+
+	btech = of_get_property(np_bat_supply, "stericsson,battery-type", NULL);
 	if (!btech) {
 		dev_warn(dev, "missing property battery-name/type\n");
 		return -EINVAL;
@@ -498,6 +497,7 @@ bmdevs_of_probe(struct device *dev,
 		bat->bat_type[BATTERY_UNKNOWN].normal_cur_lvl	  = 520;
 		bat->bat_type[BATTERY_UNKNOWN].normal_vol_lvl	  = 4200;
 	}
+
 	/* select the battery resolution table */
 	for (i = 0; i < bat->n_btypes; ++i) {
 		btype = (bat->bat_type + i);
@@ -513,5 +513,6 @@ bmdevs_of_probe(struct device *dev,
 		}
 	}
 	of_node_put(np_bat_supply);
+
 	return 0;
 }
-- 
1.7.9.5


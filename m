Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011Ab2BQQnk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 11:43:40 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:42925 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323Ab2BQQnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 11:43:39 -0500
From: Thomas Weber <thomas@tweber.de>
To: trivial@vger.kernel.org
Cc: Thomas Weber <thomas@tweber.de>, linux-kernel@vger.kernel.org
Subject: [PATCH][trivial] Fix typo milivolt => millivolt
Date: Fri, 17 Feb 2012 17:44:50 +0100
Message-Id: <1329497090-6236-1-git-send-email-thomas@tweber.de>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Weber <thomas@tweber.de>
---
 Documentation/hwmon/wm831x             |    2 +-
 drivers/mfd/tps65911-comparator.c      |    2 +-
 drivers/power/bq27x00_battery.c        |    2 +-
 drivers/regulator/tps65910-regulator.c |   20 ++++++++++----------
 include/linux/mfd/wm831x/pdata.h       |    2 +-
 5 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/Documentation/hwmon/wm831x b/Documentation/hwmon/wm831x
index 24f47d8..1144675 100644
--- a/Documentation/hwmon/wm831x
+++ b/Documentation/hwmon/wm831x
@@ -22,7 +22,7 @@ reporting of all the input values but does not provide any alarms.
 Voltage Monitoring
 ------------------
 
-Voltages are sampled by a 12 bit ADC.  Voltages in milivolts are 1.465
+Voltages are sampled by a 12 bit ADC.  Voltages in millivolts are 1.465
 times the ADC value.
 
 Temperature Monitoring
diff --git a/drivers/mfd/tps65911-comparator.c b/drivers/mfd/tps65911-comparator.c
index e7ff783..5a62e6b 100644
--- a/drivers/mfd/tps65911-comparator.c
+++ b/drivers/mfd/tps65911-comparator.c
@@ -26,7 +26,7 @@
 #define COMP1					1
 #define COMP2					2
 
-/* Comparator 1 voltage selection table in milivolts */
+/* Comparator 1 voltage selection table in millivolts */
 static const u16 COMP_VSEL_TABLE[] = {
 	0, 2500, 2500, 2500, 2500, 2550, 2600, 2650,
 	2700, 2750, 2800, 2850, 2900, 2950, 3000, 3050,
diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_battery.c
index 1ed6ea0..37968a4 100644
--- a/drivers/power/bq27x00_battery.c
+++ b/drivers/power/bq27x00_battery.c
@@ -451,7 +451,7 @@ static int bq27x00_battery_capacity_level(struct bq27x00_device_info *di,
 }
 
 /*
- * Return the battery Voltage in milivolts
+ * Return the battery Voltage in millivolts
  * Or < 0 if something fails.
  */
 static int bq27x00_battery_voltage(struct bq27x00_device_info *di,
diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
index 5c15ba0..1711dbf 100644
--- a/drivers/regulator/tps65910-regulator.c
+++ b/drivers/regulator/tps65910-regulator.c
@@ -27,54 +27,54 @@
 
 #define TPS65910_SUPPLY_STATE_ENABLED	0x1
 
-/* supported VIO voltages in milivolts */
+/* supported VIO voltages in millivolts */
 static const u16 VIO_VSEL_table[] = {
 	1500, 1800, 2500, 3300,
 };
 
 /* VSEL tables for TPS65910 specific LDOs and dcdc's */
 
-/* supported VDD3 voltages in milivolts */
+/* supported VDD3 voltages in millivolts */
 static const u16 VDD3_VSEL_table[] = {
 	5000,
 };
 
-/* supported VDIG1 voltages in milivolts */
+/* supported VDIG1 voltages in millivolts */
 static const u16 VDIG1_VSEL_table[] = {
 	1200, 1500, 1800, 2700,
 };
 
-/* supported VDIG2 voltages in milivolts */
+/* supported VDIG2 voltages in millivolts */
 static const u16 VDIG2_VSEL_table[] = {
 	1000, 1100, 1200, 1800,
 };
 
-/* supported VPLL voltages in milivolts */
+/* supported VPLL voltages in millivolts */
 static const u16 VPLL_VSEL_table[] = {
 	1000, 1100, 1800, 2500,
 };
 
-/* supported VDAC voltages in milivolts */
+/* supported VDAC voltages in millivolts */
 static const u16 VDAC_VSEL_table[] = {
 	1800, 2600, 2800, 2850,
 };
 
-/* supported VAUX1 voltages in milivolts */
+/* supported VAUX1 voltages in millivolts */
 static const u16 VAUX1_VSEL_table[] = {
 	1800, 2500, 2800, 2850,
 };
 
-/* supported VAUX2 voltages in milivolts */
+/* supported VAUX2 voltages in millivolts */
 static const u16 VAUX2_VSEL_table[] = {
 	1800, 2800, 2900, 3300,
 };
 
-/* supported VAUX33 voltages in milivolts */
+/* supported VAUX33 voltages in millivolts */
 static const u16 VAUX33_VSEL_table[] = {
 	1800, 2000, 2800, 3300,
 };
 
-/* supported VMMC voltages in milivolts */
+/* supported VMMC voltages in millivolts */
 static const u16 VMMC_VSEL_table[] = {
 	1800, 2800, 3000, 3300,
 };
diff --git a/include/linux/mfd/wm831x/pdata.h b/include/linux/mfd/wm831x/pdata.h
index 1d7a3f7..dcc9631 100644
--- a/include/linux/mfd/wm831x/pdata.h
+++ b/include/linux/mfd/wm831x/pdata.h
@@ -26,7 +26,7 @@ struct wm831x_backlight_pdata {
 struct wm831x_backup_pdata {
 	int charger_enable;
 	int no_constant_voltage;  /** Disable constant voltage charging */
-	int vlim;   /** Voltage limit in milivolts */
+	int vlim;   /** Voltage limit in millivolts */
 	int ilim;   /** Current limit in microamps */
 };
 
-- 
1.7.9.1


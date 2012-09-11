Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783Ab2IKQLi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 12:11:38 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:46895 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753740Ab2IKQLd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 12:11:33 -0400
From: Eduardo Valentin <eduardo.valentin@TI.COM>
To: <gregkh@linuxfoundation.org>
CC: <j-keerthy@TI.COM>, <b-cousson@TI.COM>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@TI.COM>
Subject: [PATCH 2/4] staging: omap-thermal: remove checkpatch.pl warnings on data files
Date: Tue, 11 Sep 2012 19:06:53 +0300
Message-ID: <1347379615-6881-3-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
In-Reply-To: <1347379615-6881-1-git-send-email-eduardo.valentin@ti.com>
References: <1347379615-6881-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simple checkpatch.pl clean ups.

Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/staging/omap-thermal/omap4-thermal.c |   54 +++++++++++++-------------
 drivers/staging/omap-thermal/omap5-thermal.c |   38 +++++++++---------
 2 files changed, 46 insertions(+), 46 deletions(-)

diff --git a/drivers/staging/omap-thermal/omap4-thermal.c b/drivers/staging/omap-thermal/omap4-thermal.c
index fa9dbcd..04c02b6 100644
--- a/drivers/staging/omap-thermal/omap4-thermal.c
+++ b/drivers/staging/omap-thermal/omap4-thermal.c
@@ -77,15 +77,15 @@ const struct omap_bandgap_data omap4430_data = {
 	.remove_sensor = omap_thermal_remove_sensor,
 	.sensors = {
 		{
-			.registers = &omap4430_mpu_temp_sensor_registers,
-			.ts_data = &omap4430_mpu_temp_sensor_data,
-			.domain = "cpu",
-			.slope = 0,
-			.constant = 20000,
-			.slope_pcb = 0,
-			.constant_pcb = 20000,
-			.register_cooling = omap_thermal_register_cpu_cooling,
-			.unregister_cooling = omap_thermal_unregister_cpu_cooling,
+		.registers = &omap4430_mpu_temp_sensor_registers,
+		.ts_data = &omap4430_mpu_temp_sensor_data,
+		.domain = "cpu",
+		.slope = 0,
+		.constant = 20000,
+		.slope_pcb = 0,
+		.constant_pcb = 20000,
+		.register_cooling = omap_thermal_register_cpu_cooling,
+		.unregister_cooling = omap_thermal_unregister_cpu_cooling,
 		},
 	},
 	.sensor_count = 1,
@@ -215,15 +215,15 @@ const struct omap_bandgap_data omap4460_data = {
 	.remove_sensor = omap_thermal_remove_sensor,
 	.sensors = {
 		{
-			.registers = &omap4460_mpu_temp_sensor_registers,
-			.ts_data = &omap4460_mpu_temp_sensor_data,
-			.domain = "cpu",
-			.slope = OMAP_GRADIENT_SLOPE_4460,
-			.constant = OMAP_GRADIENT_CONST_4460,
-			.slope_pcb = OMAP_GRADIENT_SLOPE_W_PCB_4460,
-			.constant_pcb = OMAP_GRADIENT_CONST_W_PCB_4460,
-			.register_cooling = omap_thermal_register_cpu_cooling,
-			.unregister_cooling = omap_thermal_unregister_cpu_cooling,
+		.registers = &omap4460_mpu_temp_sensor_registers,
+		.ts_data = &omap4460_mpu_temp_sensor_data,
+		.domain = "cpu",
+		.slope = OMAP_GRADIENT_SLOPE_4460,
+		.constant = OMAP_GRADIENT_CONST_4460,
+		.slope_pcb = OMAP_GRADIENT_SLOPE_W_PCB_4460,
+		.constant_pcb = OMAP_GRADIENT_CONST_W_PCB_4460,
+		.register_cooling = omap_thermal_register_cpu_cooling,
+		.unregister_cooling = omap_thermal_unregister_cpu_cooling,
 		},
 	},
 	.sensor_count = 1,
@@ -244,15 +244,15 @@ const struct omap_bandgap_data omap4470_data = {
 	.remove_sensor = omap_thermal_remove_sensor,
 	.sensors = {
 		{
-			.registers = &omap4460_mpu_temp_sensor_registers,
-			.ts_data = &omap4460_mpu_temp_sensor_data,
-			.domain = "cpu",
-			.slope = OMAP_GRADIENT_SLOPE_4470,
-			.constant = OMAP_GRADIENT_CONST_4470,
-			.slope_pcb = OMAP_GRADIENT_SLOPE_W_PCB_4470,
-			.constant_pcb = OMAP_GRADIENT_CONST_W_PCB_4470,
-			.register_cooling = omap_thermal_register_cpu_cooling,
-			.unregister_cooling = omap_thermal_unregister_cpu_cooling,
+		.registers = &omap4460_mpu_temp_sensor_registers,
+		.ts_data = &omap4460_mpu_temp_sensor_data,
+		.domain = "cpu",
+		.slope = OMAP_GRADIENT_SLOPE_4470,
+		.constant = OMAP_GRADIENT_CONST_4470,
+		.slope_pcb = OMAP_GRADIENT_SLOPE_W_PCB_4470,
+		.constant_pcb = OMAP_GRADIENT_CONST_W_PCB_4470,
+		.register_cooling = omap_thermal_register_cpu_cooling,
+		.unregister_cooling = omap_thermal_unregister_cpu_cooling,
 		},
 	},
 	.sensor_count = 1,
diff --git a/drivers/staging/omap-thermal/omap5-thermal.c b/drivers/staging/omap-thermal/omap5-thermal.c
index 0658af2..2f3a498 100644
--- a/drivers/staging/omap-thermal/omap5-thermal.c
+++ b/drivers/staging/omap-thermal/omap5-thermal.c
@@ -268,29 +268,29 @@ const struct omap_bandgap_data omap5430_data = {
 	.remove_sensor = omap_thermal_remove_sensor,
 	.sensors = {
 		{
-			.registers = &omap5430_mpu_temp_sensor_registers,
-			.ts_data = &omap5430_mpu_temp_sensor_data,
-			.domain = "cpu",
-			.register_cooling = omap_thermal_register_cpu_cooling,
-			.unregister_cooling = omap_thermal_unregister_cpu_cooling,
-			.slope = OMAP_GRADIENT_SLOPE_5430_CPU,
-			.constant = OMAP_GRADIENT_CONST_5430_CPU,
-			.slope_pcb = OMAP_GRADIENT_SLOPE_W_PCB_5430_CPU,
-			.constant_pcb = OMAP_GRADIENT_CONST_W_PCB_5430_CPU,
+		.registers = &omap5430_mpu_temp_sensor_registers,
+		.ts_data = &omap5430_mpu_temp_sensor_data,
+		.domain = "cpu",
+		.register_cooling = omap_thermal_register_cpu_cooling,
+		.unregister_cooling = omap_thermal_unregister_cpu_cooling,
+		.slope = OMAP_GRADIENT_SLOPE_5430_CPU,
+		.constant = OMAP_GRADIENT_CONST_5430_CPU,
+		.slope_pcb = OMAP_GRADIENT_SLOPE_W_PCB_5430_CPU,
+		.constant_pcb = OMAP_GRADIENT_CONST_W_PCB_5430_CPU,
 		},
 		{
-			.registers = &omap5430_gpu_temp_sensor_registers,
-			.ts_data = &omap5430_gpu_temp_sensor_data,
-			.domain = "gpu",
-			.slope = OMAP_GRADIENT_SLOPE_5430_GPU,
-			.constant = OMAP_GRADIENT_CONST_5430_GPU,
-			.slope_pcb = OMAP_GRADIENT_SLOPE_W_PCB_5430_GPU,
-			.constant_pcb = OMAP_GRADIENT_CONST_W_PCB_5430_GPU,
+		.registers = &omap5430_gpu_temp_sensor_registers,
+		.ts_data = &omap5430_gpu_temp_sensor_data,
+		.domain = "gpu",
+		.slope = OMAP_GRADIENT_SLOPE_5430_GPU,
+		.constant = OMAP_GRADIENT_CONST_5430_GPU,
+		.slope_pcb = OMAP_GRADIENT_SLOPE_W_PCB_5430_GPU,
+		.constant_pcb = OMAP_GRADIENT_CONST_W_PCB_5430_GPU,
 		},
 		{
-			.registers = &omap5430_core_temp_sensor_registers,
-			.ts_data = &omap5430_core_temp_sensor_data,
-			.domain = "core",
+		.registers = &omap5430_core_temp_sensor_registers,
+		.ts_data = &omap5430_core_temp_sensor_data,
+		.domain = "core",
 		},
 	},
 	.sensor_count = 3,
-- 
1.7.7.1.488.ge8e1c


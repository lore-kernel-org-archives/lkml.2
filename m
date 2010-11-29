Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743Ab0K2P5w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 10:57:52 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59458 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752107Ab0K2P5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 10:57:51 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: Remove duplicate consts from mc13873 driver voltage tables
Date: Mon, 29 Nov 2010 15:57:48 +0000
Message-Id: <1291046268-9271-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They're not needed and sparse is verbosely upset about them.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/mc13783-regulator.c |   36 ++++++++++++++++----------------
 1 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/regulator/mc13783-regulator.c b/drivers/regulator/mc13783-regulator.c
index 47ea999..e99917a 100644
--- a/drivers/regulator/mc13783-regulator.c
+++ b/drivers/regulator/mc13783-regulator.c
@@ -100,78 +100,78 @@ struct mc13783_regulator {
 };
 
 /* Voltage Values */
-static const int const mc13783_sw3_val[] = {
+static const int mc13783_sw3_val[] = {
 	5000000, 5000000, 5000000, 5500000,
 };
 
-static const int const mc13783_vaudio_val[] = {
+static const int mc13783_vaudio_val[] = {
 	2775000,
 };
 
-static const int const mc13783_viohi_val[] = {
+static const int mc13783_viohi_val[] = {
 	2775000,
 };
 
-static const int const mc13783_violo_val[] = {
+static const int mc13783_violo_val[] = {
 	1200000, 1300000, 1500000, 1800000,
 };
 
-static const int const mc13783_vdig_val[] = {
+static const int mc13783_vdig_val[] = {
 	1200000, 1300000, 1500000, 1800000,
 };
 
-static const int const mc13783_vgen_val[] = {
+static const int mc13783_vgen_val[] = {
 	1200000, 1300000, 1500000, 1800000,
 	1100000, 2000000, 2775000, 2400000,
 };
 
-static const int const mc13783_vrfdig_val[] = {
+static const int mc13783_vrfdig_val[] = {
 	1200000, 1500000, 1800000, 1875000,
 };
 
-static const int const mc13783_vrfref_val[] = {
+static const int mc13783_vrfref_val[] = {
 	2475000, 2600000, 2700000, 2775000,
 };
 
-static const int const mc13783_vrfcp_val[] = {
+static const int mc13783_vrfcp_val[] = {
 	2700000, 2775000,
 };
 
-static const int const mc13783_vsim_val[] = {
+static const int mc13783_vsim_val[] = {
 	1800000, 2900000, 3000000,
 };
 
-static const int const mc13783_vesim_val[] = {
+static const int mc13783_vesim_val[] = {
 	1800000, 2900000,
 };
 
-static const int const mc13783_vcam_val[] = {
+static const int mc13783_vcam_val[] = {
 	1500000, 1800000, 2500000, 2550000,
 	2600000, 2750000, 2800000, 3000000,
 };
 
-static const int const mc13783_vrfbg_val[] = {
+static const int mc13783_vrfbg_val[] = {
 	1250000,
 };
 
-static const int const mc13783_vvib_val[] = {
+static const int mc13783_vvib_val[] = {
 	1300000, 1800000, 2000000, 3000000,
 };
 
-static const int const mc13783_vmmc_val[] = {
+static const int mc13783_vmmc_val[] = {
 	1600000, 1800000, 2000000, 2600000,
 	2700000, 2800000, 2900000, 3000000,
 };
 
-static const int const mc13783_vrf_val[] = {
+static const int mc13783_vrf_val[] = {
 	1500000, 1875000, 2700000, 2775000,
 };
 
-static const int const mc13783_gpo_val[] = {
+static const int mc13783_gpo_val[] = {
 	3100000,
 };
 
-static const int const mc13783_pwgtdrv_val[] = {
+static const int mc13783_pwgtdrv_val[] = {
 	5500000,
 };
 
-- 
1.7.1


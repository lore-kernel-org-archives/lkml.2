Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751175Ab2FKTKH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 15:10:07 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:59737 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750711Ab2FKTKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 15:10:05 -0400
From: Roland Stigge <stigge@antcom.de>
To: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, b-cousson@ti.com,
        grant.likely@secretlab.ca, rob.herring@calxeda.com,
        swarren@wwwdotorg.org, robherring2@gmail.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH] ARM: omap: Fix dts files w/ status property: "disable" -> "disabled"
Date: Mon, 11 Jun 2012 21:09:44 +0200
Message-Id: <1339441785-14641-1-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patches fixes some status = "disable" strings to "disabled", the correct
way of disabling nodes in the devicetree.

Just the OMAP part here, the rest goes via other patches and trees.

Signed-off-by: Roland Stigge <stigge@antcom.de>
Acked-by: Rob Herring <rob.herring@calxeda.com>

---
Applies to v3.5-rc2

 arch/arm/boot/dts/omap3-beagle.dts |    4 +--
 arch/arm/boot/dts/omap4-panda.dts  |    6 ++---
 arch/arm/boot/dts/omap4-sdp.dts    |    4 +--
 arch/arm/boot/dts/tegra20.dtsi     |   36 +++++++++++++++++------------------
 arch/arm/boot/dts/tegra30.dtsi     |   38 ++++++++++++++++++-------------------
 5 files changed, 44 insertions(+), 44 deletions(-)

--- linux-2.6.orig/arch/arm/boot/dts/omap3-beagle.dts
+++ linux-2.6/arch/arm/boot/dts/omap3-beagle.dts
@@ -61,9 +61,9 @@
 };
 
 &mmc2 {
-	status = "disable";
+	status = "disabled";
 };
 
 &mmc3 {
-	status = "disable";
+	status = "disabled";
 };
--- linux-2.6.orig/arch/arm/boot/dts/omap4-panda.dts
+++ linux-2.6/arch/arm/boot/dts/omap4-panda.dts
@@ -74,15 +74,15 @@
 };
 
 &mmc2 {
-	status = "disable";
+	status = "disabled";
 };
 
 &mmc3 {
-	status = "disable";
+	status = "disabled";
 };
 
 &mmc4 {
-	status = "disable";
+	status = "disabled";
 };
 
 &mmc5 {
--- linux-2.6.orig/arch/arm/boot/dts/omap4-sdp.dts
+++ linux-2.6/arch/arm/boot/dts/omap4-sdp.dts
@@ -147,11 +147,11 @@
 };
 
 &mmc3 {
-	status = "disable";
+	status = "disabled";
 };
 
 &mmc4 {
-	status = "disable";
+	status = "disabled";
 };
 
 &mmc5 {

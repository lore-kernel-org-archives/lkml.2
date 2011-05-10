Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932486Ab1EJNwz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 09:52:55 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57286 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932246Ab1EJNwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 09:52:54 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: Remove some unused variables from wm831x DCDCs
Date: Tue, 10 May 2011 15:52:57 +0200
Message-Id: <1305035577-27184-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These became unused with the IRQ removal patch, I'm fairly sure that a
patch was sent earlier by someone else but it doesn't seem to have been
applied and I don't have a copy sitting around any more.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/wm831x-dcdc.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/wm831x-dcdc.c b/drivers/regulator/wm831x-dcdc.c
index e93453b..a0982e8 100644
--- a/drivers/regulator/wm831x-dcdc.c
+++ b/drivers/regulator/wm831x-dcdc.c
@@ -600,7 +600,6 @@ err:
 static __devexit int wm831x_buckv_remove(struct platform_device *pdev)
 {
 	struct wm831x_dcdc *dcdc = platform_get_drvdata(pdev);
-	struct wm831x *wm831x = dcdc->wm831x;
 
 	platform_set_drvdata(pdev, NULL);
 
@@ -776,7 +775,6 @@ err:
 static __devexit int wm831x_buckp_remove(struct platform_device *pdev)
 {
 	struct wm831x_dcdc *dcdc = platform_get_drvdata(pdev);
-	struct wm831x *wm831x = dcdc->wm831x;
 
 	platform_set_drvdata(pdev, NULL);
 
-- 
1.7.4.1


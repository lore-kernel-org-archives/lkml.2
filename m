Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891Ab1EZG56 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 02:57:58 -0400
Received: from mail.active-venture.com ([67.228.131.195]:52864 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab1EZG55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 02:57:57 -0400
X-Virus-Scan: Scanned by ClamAV 0.94.2 (no viruses);
  Thu, 26 May 2011 01:57:55 -0500
X-Originating-IP: 68.125.166.242
From: Guenter Roeck <linux@roeck-us.net>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Ian Lartey <ian@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] regulator: (wm831x-dcdc) Remove unused variables
Date: Wed, 25 May 2011 23:58:11 -0700
Message-Id: <1306393091-6036-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused variable wm831x from functions wm831x_buckv_remove() and
wm831x_buckp_remove().

This commit fixes the following build warnings:

drivers/regulator/wm831x-dcdc.c: In function wm831x_buckv_remove:
rivers/regulator/wm831x-dcdc.c:603: warning: unused variable wm831x
drivers/regulator/wm831x-dcdc.c: In function wm831x_buckp_remove:
drivers/regulator/wm831x-dcdc.c:779: warning: unused variable wm831x

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
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
1.7.1


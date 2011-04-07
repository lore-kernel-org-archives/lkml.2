Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751242Ab1DGJBG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 05:01:06 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45567 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956Ab1DGJBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 05:01:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=LbiYJ2/Qrh8v9sygbTGw2HelL7uRvZPuGX3nnBakqVULJHKlpqT4zbyfhvapHoj3CU
         EF/3t4W6S5/JnWdg10t28xNeAz2C0jMXHHNnxUsd617Swp9BTbtrnspkF2oXHdGHmrDG
         pI4Dgg8SEMyRDvsGa95TEcmbd1AfIMLbm3+8E=
From: Liu Yuan <namei.unix@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Ian Lartey <ian@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] drivers, regulator: Remove unused variable 'wm831x'
Date: Thu,  7 Apr 2011 17:00:54 +0800
Message-Id: <1302166854-9081-1-git-send-email-namei.unix@gmail.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liu Yuan <tailai.ly@taobao.com>

Variable ‘wm831x’ is not used in the function of
wm831x_buckv_remove() and wm831x_buckp_remove().This
patch removes 'em.

Signed-off-by: Liu Yuan <tailai.ly@taobao.com>
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


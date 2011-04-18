Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753776Ab1DRLAq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 07:00:46 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:59990 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671Ab1DRLAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 07:00:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=OdwwGkLL9A90RP7rZbJylgXwfRekUkq+Saze+UE+IQTQNm6RfkpNRHioqPuX+LHtqo
         ul5xtMFRmZLvfPmUvORi0vpcTPyvBAQFxoDbrj4C+tpKBpWuGJJSHfaRNiDQxVHs/G5p
         CrqWzLVeAgRxgIdlSY69XcYKYsKEibgH/5H40=
From: Liu Yuan <namei.unix@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org (open list)
Subject: [RESEND PATCH] drivers, regulator: Remove unused variable 'wm831x'
Date: Mon, 18 Apr 2011 19:00:29 +0800
Message-Id: <1303124430-9703-1-git-send-email-namei.unix@gmail.com>
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
Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
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


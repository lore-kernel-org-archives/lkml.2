Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934565Ab1JEO37 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 10:29:59 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:40830 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757730Ab1JEO35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 10:29:57 -0400
Subject: [PATCH] rtc: rtc-puv3: Add __devinit and __devexit markers for
 probe and remove
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>, Alessandro Zummo <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 Oct 2011 22:29:47 +0800
Message-ID: <1317824987.2674.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/rtc/rtc-puv3.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-puv3.c b/drivers/rtc/rtc-puv3.c
index b3eba3c..e4b6880 100644
--- a/drivers/rtc/rtc-puv3.c
+++ b/drivers/rtc/rtc-puv3.c
@@ -220,7 +220,7 @@ static void puv3_rtc_enable(struct platform_device *pdev, int en)
 	}
 }
 
-static int puv3_rtc_remove(struct platform_device *dev)
+static int __devexit puv3_rtc_remove(struct platform_device *dev)
 {
 	struct rtc_device *rtc = platform_get_drvdata(dev);
 
@@ -236,7 +236,7 @@ static int puv3_rtc_remove(struct platform_device *dev)
 	return 0;
 }
 
-static int puv3_rtc_probe(struct platform_device *pdev)
+static int __devinit puv3_rtc_probe(struct platform_device *pdev)
 {
 	struct rtc_device *rtc;
 	struct resource *res;
-- 
1.7.4.1




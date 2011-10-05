Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934798Ab1JEOn7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 10:43:59 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:37390 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934672Ab1JEOn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 10:43:58 -0400
Subject: [PATCH] rtc: rtc-mc13xxx: Staticize mc13xxx_rtc_idtable
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 Oct 2011 22:43:47 +0800
Message-ID: <1317825827.5849.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/rtc/rtc-mc13xxx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-mc13xxx.c b/drivers/rtc/rtc-mc13xxx.c
index 9d0c3b4..546f685 100644
--- a/drivers/rtc/rtc-mc13xxx.c
+++ b/drivers/rtc/rtc-mc13xxx.c
@@ -399,7 +399,7 @@ static int __exit mc13xxx_rtc_remove(struct platform_device *pdev)
 	return 0;
 }
 
-const struct platform_device_id mc13xxx_rtc_idtable[] = {
+static const struct platform_device_id mc13xxx_rtc_idtable[] = {
 	{
 		.name = "mc13783-rtc",
 	}, {
-- 
1.7.4.1




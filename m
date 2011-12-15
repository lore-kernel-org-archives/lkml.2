Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932315Ab1LOGul (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 01:50:41 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:36980 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844Ab1LOGuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 01:50:40 -0500
Message-ID: <1323931833.3305.3.camel@phoenix>
Subject: [PATCH RESEND] rtc: rtc-mc13xxx: Staticize mc13xxx_rtc_idtable
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 15 Dec 2011 14:50:33 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
It was sent on https://lkml.org/lkml/2011/10/5/201.

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




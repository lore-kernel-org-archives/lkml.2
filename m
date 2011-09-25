Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331Ab1IYLaN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Sep 2011 07:30:13 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:46578 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039Ab1IYLaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Sep 2011 07:30:11 -0400
Message-ID: <4E7F0D85.9020001@gmail.com>
Date: Sun, 25 Sep 2011 16:46:21 +0530
From: Navin P <zicrim@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.21) Gecko/20110831 Lightning/1.0b2 Thunderbird/3.1.13
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: a.zummo@towertech.it, rtc-linux@googlegroups.com, aghayal@codeaurora.org
Subject: [PATCH] Add static keyword for rtc-pm8xxx.c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Add static keyword as pm8xxx_rtc_pm_ops is not used outside this file.
 Maintain consistency with other files
 Signed-off-by: Navin P <zicrim@gmail.com>

---
 drivers/rtc/rtc-pm8xxx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-pm8xxx.c b/drivers/rtc/rtc-pm8xxx.c
index d420e9d..c9c5ee1 100644
--- a/drivers/rtc/rtc-pm8xxx.c
+++ b/drivers/rtc/rtc-pm8xxx.c
@@ -520,7 +520,7 @@ static int pm8xxx_rtc_suspend(struct device *dev)
 }
 #endif
 
-SIMPLE_DEV_PM_OPS(pm8xxx_rtc_pm_ops, pm8xxx_rtc_suspend, pm8xxx_rtc_resume);
+static SIMPLE_DEV_PM_OPS(pm8xxx_rtc_pm_ops, pm8xxx_rtc_suspend, pm8xxx_rtc_resume);
 
 static struct platform_driver pm8xxx_rtc_driver = {
 	.probe		= pm8xxx_rtc_probe,
-- 
1.7.0.4



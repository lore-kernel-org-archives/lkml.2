Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874Ab0JVFSp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 01:18:45 -0400
Received: from mail.perches.com ([173.55.12.10]:3464 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752845Ab0JVFR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 01:17:26 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Wan ZongShun <mcuos.com@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        linux-arm-kernel@lists.infradead.org, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/9] drivers/rtc: typo fix of faild to failed
Date: Thu, 21 Oct 2010 22:17:15 -0700
Message-Id: <4279ee540bfed9c40ba26698bfe7abddb8921ee4.1287724261.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1287724261.git.joe@perches.com>
References: <cover.1287724261.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/rtc/rtc-nuc900.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-nuc900.c b/drivers/rtc/rtc-nuc900.c
index 62de66a..ddb0857 100644
--- a/drivers/rtc/rtc-nuc900.c
+++ b/drivers/rtc/rtc-nuc900.c
@@ -274,7 +274,7 @@ static int __devinit nuc900_rtc_probe(struct platform_device *pdev)
 	nuc900_rtc->rtcdev = rtc_device_register(pdev->name, &pdev->dev,
 						&nuc900_rtc_ops, THIS_MODULE);
 	if (IS_ERR(nuc900_rtc->rtcdev)) {
-		dev_err(&pdev->dev, "rtc device register faild\n");
+		dev_err(&pdev->dev, "rtc device register failed\n");
 		err = PTR_ERR(nuc900_rtc->rtcdev);
 		goto fail3;
 	}
-- 
1.7.3.1.g432b3.dirty


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630Ab2HBI4a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 04:56:30 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:12568 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049Ab2HBI43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 04:56:29 -0400
X-AuditID: cbfee61a-b7f616d000004b7e-78-501a40bb007e
From: Jingoo Han <jg1.han@samsung.com>
To: "'Thierry Reding'" <thierry.reding@avionic-design.de>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 2/2] pwm: samsung: fix the number of PWMs
Date: Thu, 02 Aug 2012 17:56:27 +0900
Message-id: <002401cd708c$b3c09ed0$1b41dc70$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1wjLOvnCUgFh4zTy2BvoSx2MzRNA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCLMWRmVeSWpSXmKPExsVy+t9jAd3dDlIBBvM+WFlc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6M0zdOMxdsZq1o//iJsYFxG0sXIyeHhICJxLETf9kgbDGJC/fW
	A9lcHEICixglVjzewwjhzGaSmNy/nhWkik1ATeLLl8PsILaIgLnEkkV7mbsYOTiYBVwkjk4T
	AQkLC1hKTNt7AKycRUBVYsf+2WALeAVsJdovzWaCsAUlfky+B3YEs4CWxPqdx5kgbHmJzWve
	go2UEFCXePRXF2KTnsSTFbPYIUpEJPa9eMc4gVFgFpJJs5BMmoVk0iwkLQsYWVYxiqYWJBcU
	J6XnGuoVJ+YWl+al6yXn525iBIflM6kdjCsbLA4xCnAwKvHwriyVDBBiTSwrrsw9xCjBwawk
	wntHQipAiDclsbIqtSg/vqg0J7X4EKM0B4uSOK+x91d/IYH0xJLU7NTUgtQimCwTB6dUA2M5
	T1/v9Qib3N1cLc72NXt6j32qUercfCrHbvaZhsq/873sm2ZJJ7VKb7uR3KlX16noMIPHuTH4
	qYC7rKCtx+We3QrmFqnXE4+VX5gq0za3esHcL1KF9X8q/zWtvi17fM7zXxbbtig4dh7J3HZi
	/4T/mo/XnFTatvJk2/L6h41blnw6/I6vXEiJpTgj0VCLuag4EQD3wQSLRwIAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Samsung SoC can provide 4 PWMs; thus, the number of PWMs should be
set as 4.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/pwm/pwm-samsung.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pwm/pwm-samsung.c b/drivers/pwm/pwm-samsung.c
index e5187c0..32562c6 100644
--- a/drivers/pwm/pwm-samsung.c
+++ b/drivers/pwm/pwm-samsung.c
@@ -228,7 +228,7 @@ static int s3c_pwm_probe(struct platform_device *pdev)
 	s3c->chip.dev = &pdev->dev;
 	s3c->chip.ops = &s3c_pwm_ops;
 	s3c->chip.base = -1;
-	s3c->chip.npwm = 1;
+	s3c->chip.npwm = 4;
 
 	s3c->clk = devm_clk_get(dev, "pwm-tin");
 	if (IS_ERR(s3c->clk)) {
-- 
1.7.1



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455Ab2JVLTM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 07:19:12 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:43968 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706Ab2JVLTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 07:19:11 -0400
X-AuditID: cbfee61a-b7fa66d0000004cf-2f-50852bae2590
From: Jonghwan Choi <jhbird.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: "'Amit Daniel Kachhap'" <amit.kachhap@linaro.org>,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>
Subject: [PATCH] thermal: exynos: Fix wrong name of MODULE_DEVICE_TABLE
Date: Mon, 22 Oct 2012 20:19:10 +0900
Message-id: <000f01cdb047$0f033f10$2d09bd30$%choi@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2MyUCS5gT50iCTRbSf1QKtZtxEbQAAA55wCN9dkzA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMLMWRmVeSWpSXmKPExsVy+t9jQd112q0BBvs2qVhc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Mubt3MxX0s1X83ZjYwNjO2sXIySEhYCLx7sF5RghbTOLCvfVs
	ILaQwHRGiSu/ZbsYuYDseUwSUx7/ZwdJsAnoShxbvwWsWURAQWJz7zNWkCJmgVZGibvrX7KA
	JIQF3CXeP1oGlODgYBFQlVjeGA4S5hWwk3i29ys7hC0o8WPyPbByZgEtifU7jzNB2PISm9e8
	ZQZplRBQl3j0VxdilZXEk9/foMpFJPa9eMc4gVFgFpJJs5BMmoVk0iwkLQsYWVYxiqYWJBcU
	J6XnGuoVJ+YWl+al6yXn525iBAflM6kdjCsbLA4xCnAwKvHwaii0BgixJpYVV+YeYpTgYFYS
	4b0iBhTiTUmsrEotyo8vKs1JLT7EKM3BoiTO2+yREiAkkJ5YkpqdmlqQWgSTZeLglGpgFFHZ
	bVko+DNfyKZdSHKeXKRUxsrKVVt2nAvUvmUSdOnS920Kc679MTG5cLvY0fLTw8ydf8sWRV68
	u70lfZlB1kl3MecvJz3nxfr+5/BrdjrjYv38+pdN51a/cNFqqOZKWnb/RLuni1hM8KlQ/4VP
	FBelvrgleLP+G/+DTL5FJ+/7HPoTkG4hrsRSnJFoqMVcVJwIAGLeJV9GAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

exynos4_tmu_driver_ids should be exynos_tmu_driver_ids.

Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 drivers/thermal/exynos_thermal.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/thermal/exynos_thermal.c
b/drivers/thermal/exynos_thermal.c
index fd03e85..6dd29e4 100644
--- a/drivers/thermal/exynos_thermal.c
+++ b/drivers/thermal/exynos_thermal.c
@@ -815,7 +815,7 @@ static struct platform_device_id exynos_tmu_driver_ids[]
= {
        },
        { },
 };
-MODULE_DEVICE_TABLE(platform, exynos4_tmu_driver_ids);
+MODULE_DEVICE_TABLE(platform, exynos_tmu_driver_ids);

 static inline struct  exynos_tmu_platform_data *exynos_get_driver_data(
                        struct platform_device *pdev)
--
1.7.1


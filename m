Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247Ab2HGLWl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 07:22:41 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:64584 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317Ab2HGLWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 07:22:38 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: amit.kachhap@linaro.org, dg77.kim@samsung.com, guenter.roeck@ericsson.com,
        akpm@linux-foundation.org, sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 2/3] thermal: Exynos: Remove duplicate inclusion of err.h header file
Date: Tue,  7 Aug 2012 16:51:04 +0530
Message-Id: <1344338465-15478-2-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1344338465-15478-1-git-send-email-sachin.kamat@linaro.org>
References: <1344338465-15478-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

err.h header file was included twice.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Signed-off-by: Sachin Kamat <sachin.kamat@samsung.com>
---
 drivers/thermal/exynos_thermal.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/thermal/exynos_thermal.c b/drivers/thermal/exynos_thermal.c
index f6debad..3a7a068 100644
--- a/drivers/thermal/exynos_thermal.c
+++ b/drivers/thermal/exynos_thermal.c
@@ -33,7 +33,6 @@
 #include <linux/kobject.h>
 #include <linux/io.h>
 #include <linux/mutex.h>
-#include <linux/err.h>
 #include <linux/platform_data/exynos_thermal.h>
 #include <linux/thermal.h>
 #include <linux/cpufreq.h>
-- 
1.7.4.1


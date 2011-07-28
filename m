Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863Ab1G1FRD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 01:17:03 -0400
Received: from mail.windriver.com ([147.11.1.11]:51295 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584Ab1G1FQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 01:16:33 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: mingo@elte.hu, torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        linux-arch@vger.kernel.org
Subject: [PATCH 07/11] pm_runtime.h: explicitly requires notifier.h
Date: Thu, 28 Jul 2011 01:16:14 -0400
Message-Id: <1311830178-30314-8-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1311830178-30314-1-git-send-email-paul.gortmaker@windriver.com>
References: <1311830178-30314-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This file was getting notifier.h via device.h --> module.h but
the module.h inclusion is going away, so add notifier.h directly.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 include/linux/pm_runtime.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/pm_runtime.h b/include/linux/pm_runtime.h
index daac05d..19d6a72 100644
--- a/include/linux/pm_runtime.h
+++ b/include/linux/pm_runtime.h
@@ -10,6 +10,7 @@
 #define _LINUX_PM_RUNTIME_H
 
 #include <linux/device.h>
+#include <linux/notifier.h>
 #include <linux/pm.h>
 
 #include <linux/jiffies.h>
-- 
1.7.6


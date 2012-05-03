Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064Ab2ECJl4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 05:41:56 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64388 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226Ab2ECJlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 05:41:55 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: vinod.koul@intel.com, dan.j.williams@intel.com, jaswinder.singh@linaro.org,
        sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 1/1] DMA: PL330: Remove duplicate header file inclusion
Date: Thu,  3 May 2012 15:02:28 +0530
Message-Id: <1336037548-13718-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes <linux/interrupt.h> file which was included twice.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/dma/pl330.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index 2ee6e23..e8ebca7 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -21,7 +21,6 @@
 #include <linux/interrupt.h>
 #include <linux/dma-mapping.h>
 #include <linux/dmaengine.h>
-#include <linux/interrupt.h>
 #include <linux/amba/bus.h>
 #include <linux/amba/pl330.h>
 #include <linux/pm_runtime.h>
-- 
1.7.4.1


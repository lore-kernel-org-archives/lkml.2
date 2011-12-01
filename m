Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585Ab1LAN47 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 08:56:59 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52298 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754215Ab1LAN46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 08:56:58 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/2] mfd: Add missing mutex.h inclusion to WM8994 core.h
Date: Thu,  1 Dec 2011 13:56:53 +0000
Message-Id: <1322747814-31877-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct wm8994 includes a mutex so we need to include mutex.h before we
declare it. All current users rely on this being done implicitly.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 include/linux/mfd/wm8994/core.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/mfd/wm8994/core.h b/include/linux/mfd/wm8994/core.h
index b9a44e7..c22b352 100644
--- a/include/linux/mfd/wm8994/core.h
+++ b/include/linux/mfd/wm8994/core.h
@@ -15,6 +15,7 @@
 #ifndef __MFD_WM8994_CORE_H__
 #define __MFD_WM8994_CORE_H__
 
+#include <linux/mutex.h>
 #include <linux/interrupt.h>
 
 enum wm8994_type {
-- 
1.7.7.3


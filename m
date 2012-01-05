Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751056Ab2AEFNE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 00:13:04 -0500
Received: from mga14.intel.com ([143.182.124.37]:27821 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750767Ab2AEFNC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 00:13:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="92559878"
From: Feng Tang <feng.tang@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>,
        linux-kernel@vger.kernel.org
Cc: Feng Tang <feng.tang@intel.com>
Subject: [PATCH 1/2] time: remove the orphan option GENERIC_CLOCKEVENTS_MIGR
Date: Thu,  5 Jan 2012 21:28:04 +0800
Message-Id: <1325770085-5162-1-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Running grep only see it exit in the kernel/time/Kconfig, so remove it.

xxx@bee:~/ws2/projects/linux-2.6$ grep GENERIC_CLOCKEVENTS_MIGR ./* -r
./kernel/time/Kconfig:  depends on GENERIC_CLOCKEVENTS || GENERIC_CLOCKEVENTS_MIGR

Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 kernel/time/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
index b26c222..2cf9cc7 100644
--- a/kernel/time/Kconfig
+++ b/kernel/time/Kconfig
@@ -25,7 +25,7 @@ config HIGH_RES_TIMERS
 config GENERIC_CLOCKEVENTS_BUILD
 	bool
 	default y
-	depends on GENERIC_CLOCKEVENTS || GENERIC_CLOCKEVENTS_MIGR
+	depends on GENERIC_CLOCKEVENTS
 
 config GENERIC_CLOCKEVENTS_MIN_ADJUST
 	bool
-- 
1.7.1


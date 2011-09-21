Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751230Ab1IUNri (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 09:47:38 -0400
Received: from mga02.intel.com ([134.134.136.20]:59136 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751030Ab1IUNrg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 09:47:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="51478513"
From: Oren Weil <oren.jer.weil@intel.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        tomas.winkler@intel.com, Oren Weil <oren.jer.weil@intel.com>
Subject: [PATCH 2/2] staging: mei: clean the TODO file from done tasks.
Date: Wed, 21 Sep 2011 16:45:31 +0300
Message-Id: <1316612731-20905-2-git-send-email-oren.jer.weil@intel.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316612731-20905-1-git-send-email-oren.jer.weil@intel.com>
References: <1316612731-20905-1-git-send-email-oren.jer.weil@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Oren Weil <oren.jer.weil@intel.com>
---
 drivers/staging/mei/TODO |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/mei/TODO b/drivers/staging/mei/TODO
index 3b6a667..7d9a13b 100644
--- a/drivers/staging/mei/TODO
+++ b/drivers/staging/mei/TODO
@@ -1,14 +1,4 @@
 TODO:
-	- Create in-kernel Client API. Examples of in-kernel clients are watchdog and AMTHI.
-	- ME Watchdog Driver to expose standard Linux watchdog interface
-	- Rewrite AMTHI to use in-kernel client interface
-	- Cleanup init and probe functions
-	- Review BUG/BUG_ON usage
-	- Cleanup and reorganize header files
-	- Rewrite client data structure
-	- Make state machine more readable
-	- Add mei.txt with driver explanation and it's driver
-	- Fix Kconfig
 	- Cleanup and split the timer function
 Upon Unstaging:
 	- move mei.h to include/linux/mei.h
-- 
1.7.4.1


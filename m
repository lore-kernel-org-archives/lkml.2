Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755605Ab1IGGFf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 02:05:35 -0400
Received: from mga01.intel.com ([192.55.52.88]:6183 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755555Ab1IGGFO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 02:05:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,343,1312182000"; 
   d="scan'208";a="48789721"
From: Oren Weil <oren.jer.weil@intel.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, alan@linux.intel.com, wim@iguana.be,
        tomas.winkler@intel.com, Oren Weil <oren.jer.weil@intel.com>
Subject: [PATCH 10/12 v2] staging: mei: removing wd module parameters
Date: Wed,  7 Sep 2011 09:03:16 +0300
Message-Id: <1315375398-29529-11-git-send-email-oren.jer.weil@intel.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315375398-29529-1-git-send-email-oren.jer.weil@intel.com>
References: <1315375398-29529-1-git-send-email-oren.jer.weil@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wd module parameter is not needed now that driver is using watchdog core.

Signed-off-by: Oren Weil <oren.jer.weil@intel.com>
Acked-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/staging/mei/wd.c |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/mei/wd.c b/drivers/staging/mei/wd.c
index fd67952..b56b1cc 100644
--- a/drivers/staging/mei/wd.c
+++ b/drivers/staging/mei/wd.c
@@ -26,16 +26,6 @@
 #include "interface.h"
 #include "mei.h"
 
-/*
- * MEI Watchdog Module Parameters
- */
-static u16 watchdog_timeout = AMT_WD_DEFAULT_TIMEOUT;
-module_param(watchdog_timeout, ushort, 0);
-MODULE_PARM_DESC(watchdog_timeout,
-		"Intel(R) AMT Watchdog timeout value in seconds. (default="
-					__MODULE_STRING(AMT_WD_DEFAULT_TIMEOUT)
-					", disable=0)");
-
 static const u8 mei_start_wd_params[] = { 0x02, 0x12, 0x13, 0x10 };
 static const u8 mei_stop_wd_params[] = { 0x02, 0x02, 0x14, 0x10 };
 
-- 
1.7.4.1


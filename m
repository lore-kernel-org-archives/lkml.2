Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799Ab0LIRZO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 12:25:14 -0500
Received: from mga11.intel.com ([192.55.52.93]:58056 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755299Ab0LIRZN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 12:25:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,320,1288594800"; 
   d="scan'208";a="866415269"
From: Mark Allyn <mark.a.allyn@intel.com>
To: linux-kernel@vger.kernel.org, greg@kroah.com, mark.a.allyn@intel.com,
        alan@linux.intel.com, dmitry.kasatkin@nokia.com
Subject: [PATCH 07/11] sep: remove completed items in TODO
Date: Thu,  9 Dec 2010 09:31:57 -0800
Message-Id: <1291915917-18544-1-git-send-email-mark.a.allyn@intel.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Allyn <mark.a.allyn@intel.com>
---
 drivers/staging/sep/TODO |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/sep/TODO b/drivers/staging/sep/TODO
index 371ee27..089c240 100644
--- a/drivers/staging/sep/TODO
+++ b/drivers/staging/sep/TODO
@@ -1,12 +1,5 @@
 Todo's so far (from Alan Cox)
-- Fix firmware loading - Done 09/10 M. Allyn
-- Get firmware into firmware git tree - Firmware is non open source
-- Review and tidy each algorithm function - Done 09/10 M. Allyn
 - Check whether it can be plugged into any of the kernel crypto API
   interfaces - Crypto API 'glue' is still not ready to submit
-- Do something about the magic shared memory interface and replace it
-  with something saner (in Linux terms) - Done 09/10 M. Allyn
 - Clean up unused ioctls - Needs vendor help
 - Clean up unused fields in ioctl structures - Needs vendor help
-- 64 bit size to be used for all user space addresses passed
-  to ioctl - Done 10/10 M. Allyn
-- 
1.6.3.3


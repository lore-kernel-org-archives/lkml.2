Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755677Ab1IGGGV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 02:06:21 -0400
Received: from mga01.intel.com ([192.55.52.88]:6183 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755566Ab1IGGFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 02:05:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,343,1312182000"; 
   d="scan'208,223";a="48789743"
From: Oren Weil <oren.jer.weil@intel.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, alan@linux.intel.com, wim@iguana.be,
        tomas.winkler@intel.com, Oren Weil <oren.jer.weil@intel.com>
Subject: [PATCH 11/12 v2] staging: mei: adding mei_wd_stop function comment
Date: Wed,  7 Sep 2011 09:03:18 +0300
Message-Id: <1315375398-29529-13-git-send-email-oren.jer.weil@intel.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315375398-29529-1-git-send-email-oren.jer.weil@intel.com>
References: <1315375398-29529-1-git-send-email-oren.jer.weil@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 0d425f09d49b13b0dd8282e946bc87947a20a4a3 Mon Sep 17 00:00:00 2001
From: Oren Weil <oren.jer.weil@intel.com>
Date: Wed, 17 Aug 2011 13:22:12 +0300
Subject: [PATCH 12/12 v2] staging: mei: adding watchdog core dependency to kconfig

Signed-off-by: Oren Weil <oren.jer.weil@intel.com>
Acked-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/staging/mei/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/mei/Kconfig b/drivers/staging/mei/Kconfig
index 3f3f170..47d78a7 100644
--- a/drivers/staging/mei/Kconfig
+++ b/drivers/staging/mei/Kconfig
@@ -1,6 +1,6 @@
 config INTEL_MEI
 	tristate "Intel Management Engine Interface (Intel MEI)"
-	depends on X86 && PCI && EXPERIMENTAL
+	depends on X86 && PCI && EXPERIMENTAL && WATCHDOG_CORE
 	help
 	  The Intel Management Engine (Intel ME) provides Manageability,
 	  Security and Media services for system containing Intel chipsets.
-- 
1.7.4.1


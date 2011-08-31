Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756396Ab1HaNoi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 09:44:38 -0400
Received: from mga14.intel.com ([143.182.124.37]:5192 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756347Ab1HaNod (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 09:44:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,307,1312182000"; 
   d="scan'208";a="44295068"
From: Oren Weil <oren.jer.weil@intel.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, alan@linux.intel.com, wim@iguana.be,
        tomas.winkler@intel.com, Oren Weil <oren.jer.weil@intel.com>
Subject: [PATCH 12/12] staging: mei: adding watchdog core dependency to kconfig
Date: Wed, 31 Aug 2011 16:42:48 +0300
Message-Id: <1314798168-15613-13-git-send-email-oren.jer.weil@intel.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314798168-15613-1-git-send-email-oren.jer.weil@intel.com>
References: <1314798168-15613-1-git-send-email-oren.jer.weil@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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


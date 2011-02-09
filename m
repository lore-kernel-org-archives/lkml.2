Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112Ab1BIAS5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 19:18:57 -0500
Received: from mga09.intel.com ([134.134.136.24]:58012 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756024Ab1BIARW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 19:17:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,444,1291622400"; 
   d="scan'208";a="705558313"
From: james_p_freyensee@linux.intel.com
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, suhail.ahmed@intel.com,
        james_p_freyensee@linux.intel.com
Subject: [PATCH 04/12] PTI Kconfig change in misc.
Date: Tue,  8 Feb 2011 16:17:09 -0800
Message-Id: <1297210637-5934-4-git-send-email-james_p_freyensee@linux.intel.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1297210637-5934-3-git-send-email-james_p_freyensee@linux.intel.com>
References: <james_p_freyensee@linux.intel.com>
 <1297210637-5934-2-git-send-email-james_p_freyensee@linux.intel.com>
 <1297210637-5934-3-git-send-email-james_p_freyensee@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: J Freyensee <james_p_freyensee@linux.intel.com>

This adds the Intel PTI Kconfig option.

Signed-off-by: J Freyensee <james_p_freyensee@linux.intel.com>
---
 drivers/misc/Kconfig |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 4d073f1..f8076f1 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -136,6 +136,18 @@ config PHANTOM
 	  If you choose to build module, its name will be phantom. If unsure,
 	  say N here.
 
+config INTEL_MID_PTI
+        tristate "Parallel Trace Interface for MIPI P1149.7 cJTAG standard"
+        help
+          The PTI (Parallel Trace Interface) driver directs
+          trace data routed from various parts in the system out
+          through an Intel Penwell PTI port and out of the mobile
+          device for analysis with a debugging tool (Lauterbach or Fido).
+
+          You should select this driver if the target kernel is meant for
+          an Intel Atom (non-netbook) mobile device containing a MIPI
+          P1149.7 standard implementation.
+
 config SGI_IOC4
 	tristate "SGI IOC4 Base IO support"
 	depends on PCI
-- 
1.6.6.1


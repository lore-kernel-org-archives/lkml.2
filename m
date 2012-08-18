Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104Ab2HRRbZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 13:31:25 -0400
Received: from mga01.intel.com ([192.55.52.88]:21506 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753217Ab2HRRa2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 13:30:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,791,1336374000"; 
   d="scan'208";a="204520326"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 28/31] sections: Fix section conflicts in net/can
Date: Sat, 18 Aug 2012 10:30:19 -0700
Message-Id: <1345311022-26328-29-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345311022-26328-1-git-send-email-andi@firstfloor.org>
References: <1345311022-26328-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 net/can/af_can.c |    2 +-
 net/can/bcm.c    |    2 +-
 net/can/gw.c     |    2 +-
 net/can/raw.c    |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/can/af_can.c b/net/can/af_can.c
index 821022a..ddac1ee 100644
--- a/net/can/af_can.c
+++ b/net/can/af_can.c
@@ -63,7 +63,7 @@
 
 #include "af_can.h"
 
-static __initdata const char banner[] = KERN_INFO
+static __initconst const char banner[] = KERN_INFO
 	"can: controller area network core (" CAN_VERSION_STRING ")\n";
 
 MODULE_DESCRIPTION("Controller Area Network PF_CAN core");
diff --git a/net/can/bcm.c b/net/can/bcm.c
index 151b773..6f74758 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -77,7 +77,7 @@
 		     (CAN_SFF_MASK | CAN_EFF_FLAG | CAN_RTR_FLAG))
 
 #define CAN_BCM_VERSION CAN_VERSION
-static __initdata const char banner[] = KERN_INFO
+static __initconst const char banner[] = KERN_INFO
 	"can: broadcast manager protocol (rev " CAN_BCM_VERSION " t)\n";
 
 MODULE_DESCRIPTION("PF_CAN broadcast manager protocol");
diff --git a/net/can/gw.c b/net/can/gw.c
index b54d5e6..4fe4fc4 100644
--- a/net/can/gw.c
+++ b/net/can/gw.c
@@ -58,7 +58,7 @@
 #include <net/sock.h>
 
 #define CAN_GW_VERSION "20101209"
-static __initdata const char banner[] =
+static __initconst const char banner[] =
 	KERN_INFO "can: netlink gateway (rev " CAN_GW_VERSION ")\n";
 
 MODULE_DESCRIPTION("PF_CAN netlink gateway");
diff --git a/net/can/raw.c b/net/can/raw.c
index 3e9c893..5b0e3e3 100644
--- a/net/can/raw.c
+++ b/net/can/raw.c
@@ -55,7 +55,7 @@
 #include <net/net_namespace.h>
 
 #define CAN_RAW_VERSION CAN_VERSION
-static __initdata const char banner[] =
+static __initconst const char banner[] =
 	KERN_INFO "can: raw protocol (rev " CAN_RAW_VERSION ")\n";
 
 MODULE_DESCRIPTION("PF_CAN raw protocol");
-- 
1.7.7.6


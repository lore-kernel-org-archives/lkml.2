Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243Ab1BIKJk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 05:09:40 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46667 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764Ab1BIKHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 05:07:54 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 07/10] trivial: fix typos concerning "implementation"
Date: Wed,  9 Feb 2011 11:07:39 +0100
Message-Id: <1297246062-23777-7-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1297246062-23777-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1297246062-23777-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 Documentation/power/opp.txt        |    2 +-
 Documentation/scsi/ChangeLog.lpfc  |    2 +-
 arch/powerpc/include/asm/mmzone.h  |    2 +-
 arch/tile/include/asm/mmzone.h     |    2 +-
 arch/x86/include/asm/mmzone_32.h   |    2 +-
 drivers/media/video/cx18/cx18-io.h |    2 +-
 drivers/net/irda/toim3232-sir.c    |    2 +-
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c |    2 +-
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c |    2 +-
 fs/nfsd/nfs4callback.c             |    2 +-
 fs/ocfs2/cluster/heartbeat.c       |    2 +-
 include/net/sctp/structs.h         |    2 +-
 12 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/Documentation/power/opp.txt b/Documentation/power/opp.txt
index cd44558..95961de 100644
--- a/Documentation/power/opp.txt
+++ b/Documentation/power/opp.txt
@@ -82,7 +82,7 @@ opp_get_{voltage, freq, opp_count} fall into this category.
 
 opp_{add,enable,disable} are updaters which use mutex and implement it's own
 RCU locking mechanisms. opp_init_cpufreq_table acts as an updater and uses
-mutex to implment RCU updater strategy. These functions should *NOT* be called
+mutex to implement RCU updater strategy. These functions should *NOT* be called
 under RCU locks and other contexts that prevent blocking functions in RCU or
 mutex operations from working.
 
diff --git a/Documentation/scsi/ChangeLog.lpfc b/Documentation/scsi/ChangeLog.lpfc
index 5e83769..8b5bfa3 100644
--- a/Documentation/scsi/ChangeLog.lpfc
+++ b/Documentation/scsi/ChangeLog.lpfc
@@ -174,7 +174,7 @@ Changes from 20050201 to 20050208
 	  lpfc_sli_chipset_init static.
 	* Cleaned up references to list_head->next field in the driver.
 	* Replaced lpfc_discq_post_event with lpfc_workq_post_event.
-	* Implmented Christoph Hellwig's review from 2/5: Check for return
+	* Implemented Christoph Hellwig's review from 2/5: Check for return
 	  values of kmalloc.
 	* Integrated Christoph Hellwig's patch from 1/30: Protecting
 	  scan_tmo and friends in !FC_TRANSPORT_PATCHES_V2 &&
diff --git a/arch/powerpc/include/asm/mmzone.h b/arch/powerpc/include/asm/mmzone.h
index fd3fd58..60344eb 100644
--- a/arch/powerpc/include/asm/mmzone.h
+++ b/arch/powerpc/include/asm/mmzone.h
@@ -39,7 +39,7 @@ u64 memory_hotplug_max(void);
 #endif
 
 /*
- * Following are macros that each numa implmentation must define.
+ * Following are macros that each numa implementation must define.
  */
 
 #define node_start_pfn(nid)	(NODE_DATA(nid)->node_start_pfn)
diff --git a/arch/tile/include/asm/mmzone.h b/arch/tile/include/asm/mmzone.h
index c6344c4..a56937d 100644
--- a/arch/tile/include/asm/mmzone.h
+++ b/arch/tile/include/asm/mmzone.h
@@ -41,7 +41,7 @@ static inline int pfn_to_nid(unsigned long pfn)
 }
 
 /*
- * Following are macros that each numa implmentation must define.
+ * Following are macros that each numa implementation must define.
  */
 
 #define node_start_pfn(nid)	(NODE_DATA(nid)->node_start_pfn)
diff --git a/arch/x86/include/asm/mmzone_32.h b/arch/x86/include/asm/mmzone_32.h
index 91df7c5..7288148 100644
--- a/arch/x86/include/asm/mmzone_32.h
+++ b/arch/x86/include/asm/mmzone_32.h
@@ -69,7 +69,7 @@ static inline int pfn_to_nid(unsigned long pfn)
 }
 
 /*
- * Following are macros that each numa implmentation must define.
+ * Following are macros that each numa implementation must define.
  */
 
 #define node_start_pfn(nid)	(NODE_DATA(nid)->node_start_pfn)
diff --git a/drivers/media/video/cx18/cx18-io.h b/drivers/media/video/cx18/cx18-io.h
index 18974d8..b29fe69 100644
--- a/drivers/media/video/cx18/cx18-io.h
+++ b/drivers/media/video/cx18/cx18-io.h
@@ -28,7 +28,7 @@
 /*
  * Readback and retry of MMIO access for reliability:
  * The concept was suggested by Steve Toth <stoth@linuxtv.org>.
- * The implmentation is the fault of Andy Walls <awalls@md.metrocast.net>.
+ * The implementation is the fault of Andy Walls <awalls@md.metrocast.net>.
  *
  * *write* functions are implied to retry the mmio unless suffixed with _noretry
  * *read* functions never retry the mmio (it never helps to do so)
diff --git a/drivers/net/irda/toim3232-sir.c b/drivers/net/irda/toim3232-sir.c
index 99e1ec0..17ef584 100644
--- a/drivers/net/irda/toim3232-sir.c
+++ b/drivers/net/irda/toim3232-sir.c
@@ -336,7 +336,7 @@ static int toim3232_change_speed(struct sir_dev *dev, unsigned speed)
  * high, but it seems to have the same effect.
  *
  * This behaviour will probably work on dongles that have the RESET line connected,
- * but if not, add a flag for the IR320ST-2, and implment the above-listed proper
+ * but if not, add a flag for the IR320ST-2, and implement the above-listed proper
  * behaviour.
  *
  * RTS is inverted and then fed to BR/~D, so to put it in programming mode, we
diff --git a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
index a129a17..dde8dbc 100644
--- a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
+++ b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
@@ -164,7 +164,7 @@ static struct scsi_transport_template *cxgb3i_stt;
 /*
  * CPL (Chelsio Protocol Language) defines a message passing interface between
  * the host driver and Chelsio asic.
- * The section below implments CPLs that related to iscsi tcp connection
+ * The section below implements CPLs that related to iscsi tcp connection
  * open/close/abort and data send/receive.
  */
 
diff --git a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
index 8c04fad..af92770 100644
--- a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
+++ b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
@@ -165,7 +165,7 @@ static struct scsi_transport_template *cxgb4i_stt;
 /*
  * CPL (Chelsio Protocol Language) defines a message passing interface between
  * the host driver and Chelsio asic.
- * The section below implments CPLs that related to iscsi tcp connection
+ * The section below implements CPLs that related to iscsi tcp connection
  * open/close/abort and data send/receive.
  */
 #define DIV_ROUND_UP(n, d)	(((n) + (d) - 1) / (d))
diff --git a/fs/nfsd/nfs4callback.c b/fs/nfsd/nfs4callback.c
index 3be975e..93ab180 100644
--- a/fs/nfsd/nfs4callback.c
+++ b/fs/nfsd/nfs4callback.c
@@ -414,7 +414,7 @@ static void encode_cb_sequence4args(struct xdr_stream *xdr,
  *		void;
  *	};
  *
- * Our current back channel implmentation supports a single backchannel
+ * Our current back channel implementation supports a single backchannel
  * with a single slot.
  */
 static int decode_cb_sequence4resok(struct xdr_stream *xdr,
diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index b108e86..1c7a8c8 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -924,7 +924,7 @@ out:
 	return changed;
 }
 
-/* This could be faster if we just implmented a find_last_bit, but I
+/* This could be faster if we just implemented a find_last_bit, but I
  * don't think the circumstances warrant it. */
 static int o2hb_highest_node(unsigned long *nodes,
 			     int numbits)
diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index cc9185c..21531d9 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -1248,7 +1248,7 @@ typedef enum {
 } sctp_endpoint_type_t;
 
 /*
- * A common base class to bridge the implmentation view of a
+ * A common base class to bridge the implementation view of a
  * socket (usually listening) endpoint versus an association's
  * local endpoint.
  * This common structure is useful for several purposes:
-- 
1.7.2.3


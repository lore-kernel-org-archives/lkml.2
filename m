Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192Ab1DGQJx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 12:09:53 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:52387 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755995Ab1DGQJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 12:09:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ALupviGZP4W5uv5W9Rx+HniXPNrENKpmHNLByDGpiGQ0nDQlMdZcI+lMqJdT/iadmY
         twbip/Z3ooWrecJqD4JRvbE/zf8JmeSEc4WWCAg1HXC8lR0xWa/cLGPfqDaR9+IvyIeS
         Ku0B7alKVsFCJ96bRvGOSMUEbSUeF+OlaN4UU=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [RFC 5/6]Fix typo "recieve" in various parts of the kernel.
Date: Thu,  7 Apr 2011 09:09:26 -0700
Message-Id: <1302192567-842-5-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1302192567-842-1-git-send-email-justinmattock@gmail.com>
References: <1302192567-842-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below fixes "recieve" in various parts of the kernel.
Note: patches 2,3,4,5 are fixes to comments only(no code).

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/uwb/drp.c                                |    4 ++--
 drivers/xen/events.c                             |    2 +-
 fs/ocfs2/namei.c                                 |    2 +-
 fs/ocfs2/stackglue.h                             |    2 +-
 include/linux/cgroup.h                           |    2 +-
 include/linux/netfilter/nf_conntrack_proto_gre.h |    2 +-
 include/scsi/libiscsi_tcp.h                      |    2 +-
 include/scsi/osd_initiator.h                     |    2 +-
 kernel/cgroup.c                                  |    2 +-
 mm/slub.c                                        |    4 ++--
 net/netfilter/ipvs/ip_vs_proto_sctp.c            |    8 ++++----
 net/rds/ib_send.c                                |    2 +-
 net/rds/iw_send.c                                |    2 +-
 net/sctp/sm_statefuns.c                          |    2 +-
 net/sctp/ulpqueue.c                              |    2 +-
 net/wireless/reg.c                               |    2 +-
 sound/pci/asihpi/hpi.h                           |    2 +-
 sound/soc/atmel/atmel_ssc_dai.c                  |    2 +-
 sound/soc/omap/ams-delta.c                       |    2 +-
 19 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/uwb/drp.c b/drivers/uwb/drp.c
index a8d83e2..458326d 100644
--- a/drivers/uwb/drp.c
+++ b/drivers/uwb/drp.c
@@ -741,12 +741,12 @@ void uwb_drp_process_all(struct uwb_rc *rc, struct uwb_rc_evt_drp *drp_evt,
  * DRP notifications can occur for three different reasons:
  *
  * - UWB_DRP_NOTIF_DRP_IE_RECVD: one or more DRP IEs with the RC as
- *   the target or source have been recieved.
+ *   the target or source have been received.
  *
  *   These DRP IEs could be new or for an existing reservation.
  *
  *   If the DRP IE for an existing reservation ceases to be to
- *   recieved for at least mMaxLostBeacons, the reservation should be
+ *   received for at least mMaxLostBeacons, the reservation should be
  *   considered to be terminated.  Note that the TERMINATE reason (see
  *   below) may not always be signalled (e.g., the remote device has
  *   two or more reservations established with the RC).
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 036343b..972b805 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -5,7 +5,7 @@
  * domain gets 1024 event channels, but NR_IRQ is not that large, we
  * must dynamically map irqs<->event channels.  The event channels
  * interface with the rest of the kernel by defining a xen interrupt
- * chip.  When an event is recieved, it is mapped to an irq and sent
+ * chip.  When an event is received, it is mapped to an irq and sent
  * through the normal interrupt processing path.
  *
  * There are four kinds of events which can be mapped to an event
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 28f2cc1..e5d738c 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -2128,7 +2128,7 @@ leave:
 }
 
 /**
- * ocfs2_prep_new_orphaned_file() - Prepare the orphan dir to recieve a newly
+ * ocfs2_prep_new_orphaned_file() - Prepare the orphan dir to receive a newly
  * allocated file. This is different from the typical 'add to orphan dir'
  * operation in that the inode does not yet exist. This is a problem because
  * the orphan dir stringifies the inode block number to come up with it's
diff --git a/fs/ocfs2/stackglue.h b/fs/ocfs2/stackglue.h
index 8ce7398..1ec56fd 100644
--- a/fs/ocfs2/stackglue.h
+++ b/fs/ocfs2/stackglue.h
@@ -126,7 +126,7 @@ struct ocfs2_stack_operations {
 	 *
 	 * ->connect() must not return until it is guaranteed that
 	 *
-	 *  - Node down notifications for the filesystem will be recieved
+	 *  - Node down notifications for the filesystem will be received
 	 *    and passed to conn->cc_recovery_handler().
 	 *  - Locking requests for the filesystem will be processed.
 	 */
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index e654fa2..5ac7ebc 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -240,7 +240,7 @@ struct cgroup {
 	/* For RCU-protected deletion */
 	struct rcu_head rcu_head;
 
-	/* List of events which userspace want to recieve */
+	/* List of events which userspace want to receive */
 	struct list_head event_list;
 	spinlock_t event_list_lock;
 };
diff --git a/include/linux/netfilter/nf_conntrack_proto_gre.h b/include/linux/netfilter/nf_conntrack_proto_gre.h
index 2a10efd..6a0664c 100644
--- a/include/linux/netfilter/nf_conntrack_proto_gre.h
+++ b/include/linux/netfilter/nf_conntrack_proto_gre.h
@@ -60,7 +60,7 @@ struct gre_hdr_pptp {
 	__be16 payload_len;	/* size of ppp payload, not inc. gre header */
 	__be16 call_id;		/* peer's call_id for this session */
 	__be32 seq;		/* sequence number.  Present if S==1 */
-	__be32 ack;		/* seq number of highest packet recieved by */
+	__be32 ack;		/* seq number of highest packet received by */
 				/*  sender in this session */
 };
 
diff --git a/include/scsi/libiscsi_tcp.h b/include/scsi/libiscsi_tcp.h
index e6b9fd2..ac0cc1d 100644
--- a/include/scsi/libiscsi_tcp.h
+++ b/include/scsi/libiscsi_tcp.h
@@ -52,7 +52,7 @@ struct iscsi_segment {
 	iscsi_segment_done_fn_t	*done;
 };
 
-/* Socket connection recieve helper */
+/* Socket connection receive helper */
 struct iscsi_tcp_recv {
 	struct iscsi_hdr	*hdr;
 	struct iscsi_segment	segment;
diff --git a/include/scsi/osd_initiator.h b/include/scsi/osd_initiator.h
index 53a9e88..0a50799 100644
--- a/include/scsi/osd_initiator.h
+++ b/include/scsi/osd_initiator.h
@@ -265,7 +265,7 @@ int osd_execute_request_async(struct osd_request *or,
  * @osi           - Recievs a more detailed error report information (optional).
  * @silent        - Do not print to dmsg (Even if enabled)
  * @bad_obj_list  - Some commands act on multiple objects. Failed objects will
- *                  be recieved here (optional)
+ *                  be received here (optional)
  * @max_obj       - Size of @bad_obj_list.
  * @bad_attr_list - List of failing attributes (optional)
  * @max_attr      - Size of @bad_attr_list.
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index e31b220..25c7eb5 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -157,7 +157,7 @@ struct css_id {
 };
 
 /*
- * cgroup_event represents events which userspace want to recieve.
+ * cgroup_event represents events which userspace want to receive.
  */
 struct cgroup_event {
 	/*
diff --git a/mm/slub.c b/mm/slub.c
index f881874..cca3f8b 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3547,7 +3547,7 @@ void *__kmalloc_track_caller(size_t size, gfp_t gfpflags, unsigned long caller)
 
 	ret = slab_alloc(s, gfpflags, NUMA_NO_NODE, caller);
 
-	/* Honor the call site pointer we recieved. */
+	/* Honor the call site pointer we received. */
 	trace_kmalloc(caller, ret, size, s->size, gfpflags);
 
 	return ret;
@@ -3577,7 +3577,7 @@ void *__kmalloc_node_track_caller(size_t size, gfp_t gfpflags,
 
 	ret = slab_alloc(s, gfpflags, node, caller);
 
-	/* Honor the call site pointer we recieved. */
+	/* Honor the call site pointer we received. */
 	trace_kmalloc_node(caller, ret, size, s->size, gfpflags, node);
 
 	return ret;
diff --git a/net/netfilter/ipvs/ip_vs_proto_sctp.c b/net/netfilter/ipvs/ip_vs_proto_sctp.c
index b027ccc..d12ed53 100644
--- a/net/netfilter/ipvs/ip_vs_proto_sctp.c
+++ b/net/netfilter/ipvs/ip_vs_proto_sctp.c
@@ -566,7 +566,7 @@ static struct ipvs_sctp_nextstate
 	 * SHUTDOWN sent from the client, waitinf for SHUT ACK from the server
 	 */
 	/*
-	 * We recieved the data chuck, keep the state unchanged. I assume
+	 * We received the data chuck, keep the state unchanged. I assume
 	 * that still data chuncks  can be received by both the peers in
 	 * SHUDOWN state
 	 */
@@ -633,7 +633,7 @@ static struct ipvs_sctp_nextstate
 	 * SHUTDOWN sent from the server, waitinf for SHUTDOWN ACK from client
 	 */
 	/*
-	 * We recieved the data chuck, keep the state unchanged. I assume
+	 * We received the data chuck, keep the state unchanged. I assume
 	 * that still data chuncks  can be received by both the peers in
 	 * SHUDOWN state
 	 */
@@ -701,7 +701,7 @@ static struct ipvs_sctp_nextstate
 	 * SHUTDOWN ACK from the client, awaiting for SHUTDOWN COM from server
 	 */
 	/*
-	 * We recieved the data chuck, keep the state unchanged. I assume
+	 * We received the data chuck, keep the state unchanged. I assume
 	 * that still data chuncks  can be received by both the peers in
 	 * SHUDOWN state
 	 */
@@ -771,7 +771,7 @@ static struct ipvs_sctp_nextstate
 	 * SHUTDOWN ACK from the server, awaiting for SHUTDOWN COM from client
 	 */
 	/*
-	 * We recieved the data chuck, keep the state unchanged. I assume
+	 * We received the data chuck, keep the state unchanged. I assume
 	 * that still data chuncks  can be received by both the peers in
 	 * SHUDOWN state
 	 */
diff --git a/net/rds/ib_send.c b/net/rds/ib_send.c
index c47a511..7c4dce8 100644
--- a/net/rds/ib_send.c
+++ b/net/rds/ib_send.c
@@ -355,7 +355,7 @@ void rds_ib_send_cq_comp_handler(struct ib_cq *cq, void *context)
  *
  * Conceptually, we have two counters:
  *  -	send credits: this tells us how many WRs we're allowed
- *	to submit without overruning the reciever's queue. For
+ *	to submit without overruning the receiver's queue. For
  *	each SEND WR we post, we decrement this by one.
  *
  *  -	posted credits: this tells us how many WRs we recently
diff --git a/net/rds/iw_send.c b/net/rds/iw_send.c
index 6280ea0..545d8ee 100644
--- a/net/rds/iw_send.c
+++ b/net/rds/iw_send.c
@@ -307,7 +307,7 @@ void rds_iw_send_cq_comp_handler(struct ib_cq *cq, void *context)
  *
  * Conceptually, we have two counters:
  *  -	send credits: this tells us how many WRs we're allowed
- *	to submit without overruning the reciever's queue. For
+ *	to submit without overruning the receiver's queue. For
  *	each SEND WR we post, we decrement this by one.
  *
  *  -	posted credits: this tells us how many WRs we recently
diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 4b4eb7c..ff6a678 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -4402,7 +4402,7 @@ static sctp_disposition_t sctp_sf_violation_ctsn(
 }
 
 /* Handle protocol violation of an invalid chunk bundling.  For example,
- * when we have an association and we recieve bundled INIT-ACK, or
+ * when we have an association and we receive bundled INIT-ACK, or
  * SHUDOWN-COMPLETE, our peer is clearly violationg the "MUST NOT bundle"
  * statement from the specs.  Additinally, there might be an attacker
  * on the path and we may not want to continue this communication.
diff --git a/net/sctp/ulpqueue.c b/net/sctp/ulpqueue.c
index 1767818..f2d1de7 100644
--- a/net/sctp/ulpqueue.c
+++ b/net/sctp/ulpqueue.c
@@ -240,7 +240,7 @@ int sctp_ulpq_tail_event(struct sctp_ulpq *ulpq, struct sctp_ulpevent *event)
 		} else {
 			/*
 			 * If fragment interleave is enabled, we
-			 * can queue this to the recieve queue instead
+			 * can queue this to the receive queue instead
 			 * of the lobby.
 			 */
 			if (sctp_sk(sk)->frag_interleave)
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 3332d5b..1d17292 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -809,7 +809,7 @@ static void handle_channel(struct wiphy *wiphy,
 	if (r) {
 		/*
 		 * We will disable all channels that do not match our
-		 * recieved regulatory rule unless the hint is coming
+		 * received regulatory rule unless the hint is coming
 		 * from a Country IE and the Country IE had no information
 		 * about a band. The IEEE 802.11 spec allows for an AP
 		 * to send only a subset of the regulatory rules allowed,
diff --git a/sound/pci/asihpi/hpi.h b/sound/pci/asihpi/hpi.h
index 6fc025c..255429c 100644
--- a/sound/pci/asihpi/hpi.h
+++ b/sound/pci/asihpi/hpi.h
@@ -725,7 +725,7 @@ enum HPI_AESEBU_ERRORS {
 #define HPI_PAD_TITLE_LEN               64
 /** The text string containing the comment. */
 #define HPI_PAD_COMMENT_LEN             256
-/** The PTY when the tuner has not recieved any PTY. */
+/** The PTY when the tuner has not received any PTY. */
 #define HPI_PAD_PROGRAM_TYPE_INVALID    0xffff
 /** \} */
 
diff --git a/sound/soc/atmel/atmel_ssc_dai.c b/sound/soc/atmel/atmel_ssc_dai.c
index 5d230ce..7fbfa05 100644
--- a/sound/soc/atmel/atmel_ssc_dai.c
+++ b/sound/soc/atmel/atmel_ssc_dai.c
@@ -672,7 +672,7 @@ static int atmel_ssc_resume(struct snd_soc_dai *cpu_dai)
 	/* re-enable interrupts */
 	ssc_writel(ssc_p->ssc->regs, IER, ssc_p->ssc_state.ssc_imr);
 
-	/* Re-enable recieve and transmit as appropriate */
+	/* Re-enable receive and transmit as appropriate */
 	cr = 0;
 	cr |=
 	    (ssc_p->ssc_state.ssc_sr & SSC_BIT(SR_RXEN)) ? SSC_BIT(CR_RXEN) : 0;
diff --git a/sound/soc/omap/ams-delta.c b/sound/soc/omap/ams-delta.c
index 3167be6..d0737ed 100644
--- a/sound/soc/omap/ams-delta.c
+++ b/sound/soc/omap/ams-delta.c
@@ -330,7 +330,7 @@ static int cx81801_hangup(struct tty_struct *tty)
 	return 0;
 }
 
-/* Line discipline .recieve_buf() */
+/* Line discipline .receive_buf() */
 static void cx81801_receive(struct tty_struct *tty,
 				const unsigned char *cp, char *fp, int count)
 {
-- 
1.7.4.2


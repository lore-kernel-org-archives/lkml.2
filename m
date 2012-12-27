Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316Ab2L0Qic (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 11:38:32 -0500
Received: from server4.xboxworld.nl ([87.233.197.10]:54913 "EHLO
	server4.xboxworld.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753072Ab2L0Qi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 11:38:29 -0500
X-Greylist: delayed 319 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Dec 2012 11:38:28 EST
From: Jorrit Schippers <jorrit@ncode.nl>
To: kernel-janitors@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jorrit Schippers <jorrit@ncode.nl>
Subject: [PATCH] Replace incomming with incoming in all comments and strings
Date: Thu, 27 Dec 2012 17:33:02 +0100
Message-Id: <1356625982-4335-1-git-send-email-jorrit@ncode.nl>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jorrit Schippers <jorrit@ncode.nl>
---
 Documentation/networking/ip-sysctl.txt             |    2 +-
 .../cavium-octeon/executive/cvmx-helper-util.c     |    4 ++--
 arch/mips/include/asm/octeon/cvmx-helper-util.h    |    4 ++--
 arch/x86/kernel/cpu/perf_event_amd_ibs.c           |    2 +-
 drivers/hid/Kconfig                                |    2 +-
 drivers/isdn/hardware/eicon/divacapi.h             |    6 +++---
 drivers/isdn/hardware/eicon/pc.h                   |    4 ++--
 drivers/isdn/mISDN/l1oip_core.c                    |    2 +-
 drivers/media/platform/soc_camera/mx2_camera.c     |    2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c   |    2 +-
 drivers/net/ethernet/mellanox/mlx4/en_main.c       |    2 +-
 drivers/net/irda/ali-ircc.c                        |    2 +-
 drivers/staging/android/binder.h                   |    2 +-
 drivers/staging/octeon/ethernet.c                  |    2 +-
 drivers/tty/ipwireless/hardware.c                  |    4 ++--
 include/net/irda/irlmp.h                           |    2 +-
 include/net/irda/irttp.h                           |    2 +-
 net/bluetooth/hci_core.c                           |    2 +-
 net/irda/timer.c                                   |    2 +-
 net/sctp/sm_make_chunk.c                           |    2 +-
 20 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
index dd52d51..b3d239e 100644
--- a/Documentation/networking/ip-sysctl.txt
+++ b/Documentation/networking/ip-sysctl.txt
@@ -215,7 +215,7 @@ tcp_ecn - INTEGER
 	Possible values are:
 		0 Disable ECN.  Neither initiate nor accept ECN.
 		1 Always request ECN on outgoing connection attempts.
-		2 Enable ECN when requested by incomming connections
+		2 Enable ECN when requested by incoming connections
 		  but do not request ECN on outgoing connections.
 	Default: 2
 
diff --git a/arch/mips/cavium-octeon/executive/cvmx-helper-util.c b/arch/mips/cavium-octeon/executive/cvmx-helper-util.c
index 116dea1..dfdfe8b 100644
--- a/arch/mips/cavium-octeon/executive/cvmx-helper-util.c
+++ b/arch/mips/cavium-octeon/executive/cvmx-helper-util.c
@@ -175,7 +175,7 @@ int cvmx_helper_dump_packet(cvmx_wqe_t *work)
  *               Packets will begin slowly dropping when there are less than
  *               this many packet buffers free in FPA 0.
  * @drop_thresh:
- *               All incomming packets will be dropped when there are less
+ *               All incoming packets will be dropped when there are less
  *               than this many free packet buffers in FPA 0.
  * Returns Zero on success. Negative on failure
  */
@@ -210,7 +210,7 @@ int cvmx_helper_setup_red_queue(int queue, int pass_thresh, int drop_thresh)
  *               Packets will begin slowly dropping when there are less than
  *               this many packet buffers free in FPA 0.
  * @drop_thresh:
- *               All incomming packets will be dropped when there are less
+ *               All incoming packets will be dropped when there are less
  *               than this many free packet buffers in FPA 0.
  * Returns Zero on success. Negative on failure
  */
diff --git a/arch/mips/include/asm/octeon/cvmx-helper-util.h b/arch/mips/include/asm/octeon/cvmx-helper-util.h
index 6a6e52f..01c8ddd 100644
--- a/arch/mips/include/asm/octeon/cvmx-helper-util.h
+++ b/arch/mips/include/asm/octeon/cvmx-helper-util.h
@@ -60,7 +60,7 @@ extern int cvmx_helper_dump_packet(cvmx_wqe_t *work);
  *               Packets will begin slowly dropping when there are less than
  *               this many packet buffers free in FPA 0.
  * @drop_thresh:
- *               All incomming packets will be dropped when there are less
+ *               All incoming packets will be dropped when there are less
  *               than this many free packet buffers in FPA 0.
  * Returns Zero on success. Negative on failure
  */
@@ -74,7 +74,7 @@ extern int cvmx_helper_setup_red_queue(int queue, int pass_thresh,
  *               Packets will begin slowly dropping when there are less than
  *               this many packet buffers free in FPA 0.
  * @drop_thresh:
- *               All incomming packets will be dropped when there are less
+ *               All incoming packets will be dropped when there are less
  *               than this many free packet buffers in FPA 0.
  * Returns Zero on success. Negative on failure
  */
diff --git a/arch/x86/kernel/cpu/perf_event_amd_ibs.c b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
index 6336bcb..5f0581e 100644
--- a/arch/x86/kernel/cpu/perf_event_amd_ibs.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
@@ -528,7 +528,7 @@ static int perf_ibs_handle_irq(struct perf_ibs *perf_ibs, struct pt_regs *iregs)
 	if (!test_bit(IBS_STARTED, pcpu->state)) {
 		/*
 		 * Catch spurious interrupts after stopping IBS: After
-		 * disabling IBS there could be still incomming NMIs
+		 * disabling IBS there could be still incoming NMIs
 		 * with samples that even have the valid bit cleared.
 		 * Mark all this NMIs as handled.
 		 */
diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index e7d6a13..eae0c7e 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -320,7 +320,7 @@ config HID_LOGITECH_DJ
 	Say Y if you want support for Logitech Unifying receivers and devices.
 	Unifying receivers are capable of pairing up to 6 Logitech compliant
 	devices to the same receiver. Without this driver it will be handled by
-	generic USB_HID driver and all incomming events will be multiplexed
+	generic USB_HID driver and all incoming events will be multiplexed
 	into a single mouse and a single keyboard device.
 
 config LOGITECH_FF
diff --git a/drivers/isdn/hardware/eicon/divacapi.h b/drivers/isdn/hardware/eicon/divacapi.h
index 3942efb..a315a29 100644
--- a/drivers/isdn/hardware/eicon/divacapi.h
+++ b/drivers/isdn/hardware/eicon/divacapi.h
@@ -422,11 +422,11 @@ struct _DIVA_CAPI_ADAPTER {
 #define LAPD            6       /* lapd (Q.921)                     */
 #define X25_L2          7       /* x.25 layer-2                     */
 #define V120_L2         8       /* V.120 layer-2 protocol           */
-#define V42_IN          9       /* V.42 layer-2 protocol, incomming */
+#define V42_IN          9       /* V.42 layer-2 protocol, incoming */
 #define V42            10       /* V.42 layer-2 protocol            */
 #define MDM_ATP        11       /* AT Parser built in the L2        */
 #define X75_V42BIS     12       /* ISO7776 (X.75 SLP) modified to support V.42 bis compression */
-#define RTPL2_IN       13       /* RTP layer-2 protocol, incomming  */
+#define RTPL2_IN       13       /* RTP layer-2 protocol, incoming  */
 #define RTPL2          14       /* RTP layer-2 protocol             */
 #define V120_V42BIS    15       /* V.120 layer-2 protocol supporting V.42 bis compression */
 
@@ -1125,7 +1125,7 @@ extern word li_total_channels;
   | Direction           | word | Enable compression/decompression for    |
   |                     |      | 0: All direction                        |
   |                     |      | 1: disable outgoing data                |
-  |                     |      | 2: disable incomming data               |
+  |                     |      | 2: disable incoming data               |
   |                     |      | 3: disable both direction (default)     |
   +---------------------+------+-----------------------------------------+
   | Number of code      | word | Parameter P1 of V.42bis in accordance   |
diff --git a/drivers/isdn/hardware/eicon/pc.h b/drivers/isdn/hardware/eicon/pc.h
index 889dc98..329c0c2 100644
--- a/drivers/isdn/hardware/eicon/pc.h
+++ b/drivers/isdn/hardware/eicon/pc.h
@@ -419,11 +419,11 @@ struct dual
 #define LAPD            6       /* lapd (Q.921)                     */
 #define X25_L2          7       /* x.25 layer-2                     */
 #define V120_L2         8       /* V.120 layer-2 protocol           */
-#define V42_IN          9       /* V.42 layer-2 protocol, incomming */
+#define V42_IN          9       /* V.42 layer-2 protocol, incoming */
 #define V42            10       /* V.42 layer-2 protocol            */
 #define MDM_ATP        11       /* AT Parser built in the L2        */
 #define X75_V42BIS     12       /* x.75 with V.42bis                */
-#define RTPL2_IN       13       /* RTP layer-2 protocol, incomming  */
+#define RTPL2_IN       13       /* RTP layer-2 protocol, incoming  */
 #define RTPL2          14       /* RTP layer-2 protocol             */
 #define V120_V42BIS    15       /* V.120 asynchronous mode supporting V.42bis compression */
 #define LISTENER       27       /* Layer 2 to listen line */
diff --git a/drivers/isdn/mISDN/l1oip_core.c b/drivers/isdn/mISDN/l1oip_core.c
index f8e405c..2c0d2c2 100644
--- a/drivers/isdn/mISDN/l1oip_core.c
+++ b/drivers/isdn/mISDN/l1oip_core.c
@@ -689,7 +689,7 @@ l1oip_socket_thread(void *data)
 	hc->sin_remote.sin_addr.s_addr = htonl(hc->remoteip);
 	hc->sin_remote.sin_port = htons((unsigned short)hc->remoteport);
 
-	/* bind to incomming port */
+	/* bind to incoming port */
 	if (socket->ops->bind(socket, (struct sockaddr *)&hc->sin_local,
 			      sizeof(hc->sin_local))) {
 		printk(KERN_ERR "%s: Failed to bind socket to port %d.\n",
diff --git a/drivers/media/platform/soc_camera/mx2_camera.c b/drivers/media/platform/soc_camera/mx2_camera.c
index 791cd1d..e76dc4d 100644
--- a/drivers/media/platform/soc_camera/mx2_camera.c
+++ b/drivers/media/platform/soc_camera/mx2_camera.c
@@ -345,7 +345,7 @@ static struct mx2_fmt_cfg mx27_emma_prp_table[] = {
 	/*
 	 * This is a generic configuration which is valid for most
 	 * prp input-output format combinations.
-	 * We set the incomming and outgoing pixelformat to a
+	 * We set the incoming and outgoing pixelformat to a
 	 * 16 Bit wide format and adjust the bytesperline
 	 * accordingly. With this configuration the inputdata
 	 * will not be changed by the emma and could be any type
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index 940ef85..7cb1425 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -8678,7 +8678,7 @@ static void bnx2x_set_234_gates(struct bnx2x *bp, bool close)
 		       (!close) ? (val | HC_CONFIG_0_REG_BLOCK_DISABLE_0) :
 		       (val & ~(u32)HC_CONFIG_0_REG_BLOCK_DISABLE_0));
 	} else {
-		/* Prevent incomming interrupts in IGU */
+		/* Prevent incoming interrupts in IGU */
 		val = REG_RD(bp, IGU_REG_BLOCK_CONFIGURATION);
 
 		REG_WR(bp, IGU_REG_BLOCK_CONFIGURATION,
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_main.c b/drivers/net/ethernet/mellanox/mlx4/en_main.c
index 3a2b8c6..8611c89 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_main.c
@@ -64,7 +64,7 @@ static const char mlx4_en_version[] =
 
 /* Enable RSS UDP traffic */
 MLX4_EN_PARM_INT(udp_rss, 1,
-		 "Enable RSS for incomming UDP traffic or disabled (0)");
+		 "Enable RSS for incoming UDP traffic or disabled (0)");
 
 /* Priority pausing */
 MLX4_EN_PARM_INT(pfctx, 0, "Priority based Flow Control policy on TX[7:0]."
diff --git a/drivers/net/irda/ali-ircc.c b/drivers/net/irda/ali-ircc.c
index 8487204..9cea451 100644
--- a/drivers/net/irda/ali-ircc.c
+++ b/drivers/net/irda/ali-ircc.c
@@ -993,7 +993,7 @@ static void ali_ircc_change_speed(struct ali_ircc_cb *self, __u32 baud)
 		/* Enable Interuupt */
 		self->ier = IER_EOM; // benjamin 2000/11/20 07:24PM					
 				
-		/* Be ready for incomming frames */
+		/* Be ready for incoming frames */
 		ali_ircc_dma_receive(self);	// benajmin 2000/11/8 07:46PM not complete
 	}	
 	/* Go to SIR Speed */
diff --git a/drivers/staging/android/binder.h b/drivers/staging/android/binder.h
index 2f7d195..629372f 100644
--- a/drivers/staging/android/binder.h
+++ b/drivers/staging/android/binder.h
@@ -224,7 +224,7 @@ enum BinderDriverReturnProtocol {
 	BR_SPAWN_LOOPER = _IO('r', 13),
 	/*
 	 * No parameters.  The driver has determined that a process has no
-	 * threads waiting to service incomming transactions.  When a process
+	 * threads waiting to service incoming transactions.  When a process
 	 * receives this command, it must spawn a new service thread and
 	 * register it via bcENTER_LOOPER.
 	 */
diff --git a/drivers/staging/octeon/ethernet.c b/drivers/staging/octeon/ethernet.c
index ef32dc1..1335283 100644
--- a/drivers/staging/octeon/ethernet.c
+++ b/drivers/staging/octeon/ethernet.c
@@ -72,7 +72,7 @@ int pow_receive_group = 15;
 module_param(pow_receive_group, int, 0444);
 MODULE_PARM_DESC(pow_receive_group, "\n"
 	"\tPOW group to receive packets from. All ethernet hardware\n"
-	"\twill be configured to send incomming packets to this POW\n"
+	"\twill be configured to send incoming packets to this POW\n"
 	"\tgroup. Also any other software can submit packets to this\n"
 	"\tgroup for the kernel to process.");
 
diff --git a/drivers/tty/ipwireless/hardware.c b/drivers/tty/ipwireless/hardware.c
index b4ba067..97a511f 100644
--- a/drivers/tty/ipwireless/hardware.c
+++ b/drivers/tty/ipwireless/hardware.c
@@ -646,7 +646,7 @@ static void queue_received_packet(struct ipw_hardware *hw,
 		(*assem) = pool_allocate(hw, *assem, length);
 		if (!(*assem)) {
 			printk(KERN_ERR IPWIRELESS_PCCARD_NAME
-				": no memory for incomming data packet, dropped!\n");
+				": no memory for incoming data packet, dropped!\n");
 			return;
 		}
 		(*assem)->protocol = protocol;
@@ -670,7 +670,7 @@ static void queue_received_packet(struct ipw_hardware *hw,
 		packet = pool_allocate(hw, NULL, length);
 		if (!packet) {
 			printk(KERN_ERR IPWIRELESS_PCCARD_NAME
-				": no memory for incomming ctrl packet, dropped!\n");
+				": no memory for incoming ctrl packet, dropped!\n");
 			return;
 		}
 		packet->protocol = protocol;
diff --git a/include/net/irda/irlmp.h b/include/net/irda/irlmp.h
index 591f786..f741091 100644
--- a/include/net/irda/irlmp.h
+++ b/include/net/irda/irlmp.h
@@ -278,7 +278,7 @@ static inline int irlmp_lap_tx_queue_full(struct lsap_cb *self)
 }
 
 /* After doing a irlmp_dup(), this get one of the two socket back into
- * a state where it's waiting incomming connections.
+ * a state where it's waiting incoming connections.
  * Note : this can be used *only* if the socket is not yet connected
  * (i.e. NO irlmp_connect_response() done on this socket).
  * - Jean II */
diff --git a/include/net/irda/irttp.h b/include/net/irda/irttp.h
index af4b877..98682d4 100644
--- a/include/net/irda/irttp.h
+++ b/include/net/irda/irttp.h
@@ -185,7 +185,7 @@ static inline __u32 irttp_get_max_seg_size(struct tsap_cb *self)
 }
 
 /* After doing a irttp_dup(), this get one of the two socket back into
- * a state where it's waiting incomming connections.
+ * a state where it's waiting incoming connections.
  * Note : this can be used *only* if the socket is not yet connected
  * (i.e. NO irttp_connect_response() done on this socket).
  * - Jean II */
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 596660d..6ed79a4 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1921,7 +1921,7 @@ int hci_recv_frame(struct sk_buff *skb)
 		return -ENXIO;
 	}
 
-	/* Incomming skb */
+	/* Incoming skb */
 	bt_cb(skb)->incoming = 1;
 
 	/* Time stamp */
diff --git a/net/irda/timer.c b/net/irda/timer.c
index 1d552b3..0c4c115 100644
--- a/net/irda/timer.c
+++ b/net/irda/timer.c
@@ -57,7 +57,7 @@ void irlap_start_query_timer(struct irlap_cb *self, int S, int s)
 	 * Basically, we multiply the number of remaining slots by our
 	 * slot time, plus add some extra time to properly receive the last
 	 * discovery packet (which is longer due to extra discovery info),
-	 * to avoid messing with for incomming connections requests and
+	 * to avoid messing with for incoming connections requests and
 	 * to accommodate devices that perform discovery slower than us.
 	 * Jean II */
 	timeout = ((sysctl_slot_timeout * HZ / 1000) * (S - s)
diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index e1c5fc2..04df530 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -1201,7 +1201,7 @@ nodata:
  * specifically, max(asoc->pathmtu, SCTP_DEFAULT_MAXSEGMENT)
  * This is a helper function to allocate an error chunk for
  * for those invalid parameter codes in which we may not want
- * to report all the errors, if the incomming chunk is large
+ * to report all the errors, if the incoming chunk is large
  */
 static inline struct sctp_chunk *sctp_make_op_error_fixed(
 	const struct sctp_association *asoc,
-- 
1.7.8.6


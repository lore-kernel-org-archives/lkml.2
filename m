Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723Ab1HQN6O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 09:58:14 -0400
Received: from wondertoys-mx.wondertoys.net ([206.117.179.246]:44476 "EHLO
	labridge.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753539Ab1HQN6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 09:58:08 -0400
Subject: [trivial PATCH next] treewide: Correct spelling of successfully
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Aug 2011 06:58:04 -0700
Message-ID: <1313589485.32547.5.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---

Just noticed it doing something else, might as well fix it.

 drivers/media/video/cx18/cx18-mailbox.h     |    2 +-
 drivers/media/video/s5p-fimc/fimc-capture.c |    2 +-
 drivers/net/igb/e1000_mbx.c                 |    2 +-
 drivers/net/igbvf/mbx.c                     |    2 +-
 drivers/net/ixgbe/ixgbe_mbx.c               |    2 +-
 drivers/net/ixgbevf/mbx.c                   |    2 +-
 drivers/net/phy/broadcom.c                  |    2 +-
 drivers/net/tile/tilepro.c                  |    2 +-
 drivers/target/iscsi/iscsi_target_nego.c    |    2 +-
 drivers/target/target_core_tpg.c            |    2 +-
 kernel/sched.c                              |    2 +-
 sound/core/memalloc.c                       |    4 ++--
 12 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/media/video/cx18/cx18-mailbox.h b/drivers/media/video/cx18/cx18-mailbox.h
index 05fe6bd..b63fdfa 100644
--- a/drivers/media/video/cx18/cx18-mailbox.h
+++ b/drivers/media/video/cx18/cx18-mailbox.h
@@ -69,7 +69,7 @@ struct cx18_mailbox {
     /* Each command can have up to 6 arguments */
     u32       args[MAX_MB_ARGUMENTS];
     /* The return code can be one of the codes in the file cx23418.h. If the
-       command is completed successfuly, the error will be ERR_SYS_SUCCESS.
+       command is completed successfully, the error will be ERR_SYS_SUCCESS.
        If it is pending, the code is ERR_SYS_PENDING. If it failed, the error
        code would indicate the task from which the error originated and will
        be one of the errors in cx23418.h. In that case, the following
diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index 6685042..d5bd989 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -51,7 +51,7 @@ static struct v4l2_subdev *fimc_subdev_register(struct fimc_dev *fimc,
 		return NULL;
 	}
 
-	v4l2_info(&vid_cap->v4l2_dev, "subdevice %s registered successfuly\n",
+	v4l2_info(&vid_cap->v4l2_dev, "subdevice %s registered successfully\n",
 		isp_info->board_info->type);
 
 	return sd;
diff --git a/drivers/net/igb/e1000_mbx.c b/drivers/net/igb/e1000_mbx.c
index 74f2f11..469d95e 100644
--- a/drivers/net/igb/e1000_mbx.c
+++ b/drivers/net/igb/e1000_mbx.c
@@ -34,7 +34,7 @@
  *  @size: Length of buffer
  *  @mbx_id: id of mailbox to read
  *
- *  returns SUCCESS if it successfuly read message from buffer
+ *  returns SUCCESS if it successfully read message from buffer
  **/
 s32 igb_read_mbx(struct e1000_hw *hw, u32 *msg, u16 size, u16 mbx_id)
 {
diff --git a/drivers/net/igbvf/mbx.c b/drivers/net/igbvf/mbx.c
index 3d6f4cc..048aae2 100644
--- a/drivers/net/igbvf/mbx.c
+++ b/drivers/net/igbvf/mbx.c
@@ -288,7 +288,7 @@ out_no_write:
  *  @msg: The message buffer
  *  @size: Length of buffer
  *
- *  returns SUCCESS if it successfuly read message from buffer
+ *  returns SUCCESS if it successfully read message from buffer
  **/
 static s32 e1000_read_mbx_vf(struct e1000_hw *hw, u32 *msg, u16 size)
 {
diff --git a/drivers/net/ixgbe/ixgbe_mbx.c b/drivers/net/ixgbe/ixgbe_mbx.c
index 1ff0eef..3f725d4 100644
--- a/drivers/net/ixgbe/ixgbe_mbx.c
+++ b/drivers/net/ixgbe/ixgbe_mbx.c
@@ -38,7 +38,7 @@
  *  @size: Length of buffer
  *  @mbx_id: id of mailbox to read
  *
- *  returns SUCCESS if it successfuly read message from buffer
+ *  returns SUCCESS if it successfully read message from buffer
  **/
 s32 ixgbe_read_mbx(struct ixgbe_hw *hw, u32 *msg, u16 size, u16 mbx_id)
 {
diff --git a/drivers/net/ixgbevf/mbx.c b/drivers/net/ixgbevf/mbx.c
index 7a88331..930fa83 100644
--- a/drivers/net/ixgbevf/mbx.c
+++ b/drivers/net/ixgbevf/mbx.c
@@ -276,7 +276,7 @@ out_no_write:
  *  @msg: The message buffer
  *  @size: Length of buffer
  *
- *  returns 0 if it successfuly read message from buffer
+ *  returns 0 if it successfully read message from buffer
  **/
 static s32 ixgbevf_read_mbx_vf(struct ixgbe_hw *hw, u32 *msg, u16 size)
 {
diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
index d84c422..e8be47d 100644
--- a/drivers/net/phy/broadcom.c
+++ b/drivers/net/phy/broadcom.c
@@ -553,7 +553,7 @@ static int bcm5481_config_aneg(struct phy_device *phydev)
 		/*
 		 * There is no BCM5481 specification available, so down
 		 * here is everything we know about "register 0x18". This
-		 * at least helps BCM5481 to successfuly receive packets
+		 * at least helps BCM5481 to successfully receive packets
 		 * on MPC8360E-RDK board. Peter Barada <peterb@logicpd.com>
 		 * says: "This sets delay between the RXD and RXC signals
 		 * instead of using trace lengths to achieve timing".
diff --git a/drivers/net/tile/tilepro.c b/drivers/net/tile/tilepro.c
index 1e2af96..7b46e75d 100644
--- a/drivers/net/tile/tilepro.c
+++ b/drivers/net/tile/tilepro.c
@@ -177,7 +177,7 @@ struct tile_net_cpu {
 	struct tile_net_stats_t stats;
 	/* True iff NAPI is enabled. */
 	bool napi_enabled;
-	/* True if this tile has succcessfully registered with the IPP. */
+	/* True if this tile has successfully registered with the IPP. */
 	bool registered;
 	/* True if the link was down last time we tried to register. */
 	bool link_down;
diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index 4d087ac..426cd4b 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -504,7 +504,7 @@ static int iscsi_target_do_authentication(
 		break;
 	case 1:
 		pr_debug("iSCSI security negotiation"
-			" completed sucessfully.\n");
+			" completed successfully.\n");
 		login->auth_complete = 1;
 		if ((login_req->flags & ISCSI_FLAG_LOGIN_NEXT_STAGE1) &&
 		    (login_req->flags & ISCSI_FLAG_LOGIN_TRANSIT)) {
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index 4f1ba4c..4ada783 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -585,7 +585,7 @@ int core_tpg_set_initiator_node_queue_depth(
 	if (init_sess)
 		tpg->se_tpg_tfo->close_session(init_sess);
 
-	pr_debug("Successfuly changed queue depth to: %d for Initiator"
+	pr_debug("Successfully changed queue depth to: %d for Initiator"
 		" Node: %s on %s Target Portal Group: %u\n", queue_depth,
 		initiatorname, tpg->se_tpg_tfo->get_fabric_name(),
 		tpg->se_tpg_tfo->tpg_get_tag(tpg));
diff --git a/kernel/sched.c b/kernel/sched.c
index 7c0c81b..04cc946 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1739,7 +1739,7 @@ static inline void __set_task_cpu(struct task_struct *p, unsigned int cpu)
 #ifdef CONFIG_SMP
 	/*
 	 * After ->cpu is set up to a new value, task_rq_lock(p, ...) can be
-	 * successfuly executed on another CPU. We must ensure that updates of
+	 * successfully executed on another CPU. We must ensure that updates of
 	 * per-task data have been completed by this moment.
 	 */
 	smp_wmb();
diff --git a/sound/core/memalloc.c b/sound/core/memalloc.c
index 16bd9c0..6915692 100644
--- a/sound/core/memalloc.c
+++ b/sound/core/memalloc.c
@@ -176,7 +176,7 @@ static void snd_free_dev_pages(struct device *dev, size_t size, void *ptr,
  * Calls the memory-allocator function for the corresponding
  * buffer type.
  * 
- * Returns zero if the buffer with the given size is allocated successfuly,
+ * Returns zero if the buffer with the given size is allocated successfully,
  * other a negative value at error.
  */
 int snd_dma_alloc_pages(int type, struct device *device, size_t size,
@@ -230,7 +230,7 @@ int snd_dma_alloc_pages(int type, struct device *device, size_t size,
  * tries to allocate again.  The size actually allocated is stored in
  * res_size argument.
  * 
- * Returns zero if the buffer with the given size is allocated successfuly,
+ * Returns zero if the buffer with the given size is allocated successfully,
  * other a negative value at error.
  */
 int snd_dma_alloc_pages_fallback(int type, struct device *device, size_t size,



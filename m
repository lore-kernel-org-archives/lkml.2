Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760080Ab2HJAHZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 20:07:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54766 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754963Ab2HJAHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 20:07:23 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: linux-kernel@vger.kernel.org, trivial@kernel.org, sean.hefty@intel.com,
        hal.rosenstock@gmail.com, linux-rdma@vger.kernel.org,
        roland@kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH/v2] [trivial] infiniband: Fix typo in infiniband driver
Date: Fri, 10 Aug 2012 09:07:58 +0900
Message-Id: <1344557278-6407-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.12.rc2.9.ge5acacf
In-Reply-To: <1344555100-3992-1-git-send-email-standby24x7@gmail.com>
References: <1344555100-3992-1-git-send-email-standby24x7@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling typo in infiniband/hw and infiniband/ulp

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/infiniband/hw/amso1100/c2_rnic.c | 2 +-
 drivers/infiniband/hw/cxgb3/iwch_cm.c    | 2 +-
 drivers/infiniband/hw/qib/qib_sd7220.c   | 2 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c    | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/amso1100/c2_rnic.c b/drivers/infiniband/hw/amso1100/c2_rnic.c
index 8c81992..b80867e 100644
--- a/drivers/infiniband/hw/amso1100/c2_rnic.c
+++ b/drivers/infiniband/hw/amso1100/c2_rnic.c
@@ -439,7 +439,7 @@ static int c2_rnic_close(struct c2_dev *c2dev)
 
 /*
  * Called by c2_probe to initialize the RNIC. This principally
- * involves initalizing the various limits and resouce pools that
+ * involves initializing the various limits and resource pools that
  * comprise the RNIC instance.
  */
 int __devinit c2_rnic_init(struct c2_dev *c2dev)
diff --git a/drivers/infiniband/hw/cxgb3/iwch_cm.c b/drivers/infiniband/hw/cxgb3/iwch_cm.c
index 77b6b18..aaf88ef9 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_cm.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_cm.c
@@ -1680,7 +1680,7 @@ static int close_con_rpl(struct t3cdev *tdev, struct sk_buff *skb, void *ctx)
  * T3A does 3 things when a TERM is received:
  * 1) send up a CPL_RDMA_TERMINATE message with the TERM packet
  * 2) generate an async event on the QP with the TERMINATE opcode
- * 3) post a TERMINATE opcde cqe into the associated CQ.
+ * 3) post a TERMINATE opcode cqe into the associated CQ.
  *
  * For (1), we save the message in the qp for later consumer consumption.
  * For (2), we move the QP into TERMINATE, post a QP event and disconnect.
diff --git a/drivers/infiniband/hw/qib/qib_sd7220.c b/drivers/infiniband/hw/qib/qib_sd7220.c
index a322d51..50a8a0d 100644
--- a/drivers/infiniband/hw/qib/qib_sd7220.c
+++ b/drivers/infiniband/hw/qib/qib_sd7220.c
@@ -372,7 +372,7 @@ static void qib_sd_trimdone_monitor(struct qib_devdata *dd,
 		/* Read CTRL reg for each channel to check TRIMDONE */
 		if (baduns & (1 << chn)) {
 			qib_dev_err(dd,
-				"Reseting TRIMDONE on chn %d (%s)\n",
+				"Resetting TRIMDONE on chn %d (%s)\n",
 				chn, where);
 			ret = qib_sd7220_reg_mod(dd, IB_7220_SERDES,
 				IB_CTRL2(chn), 0x10, 0x10);
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 7a0ce8d..9e1449f 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1469,7 +1469,7 @@ static void srpt_handle_send_comp(struct srpt_rdma_ch *ch,
  *
  * XXX: what is now target_execute_cmd used to be asynchronous, and unmapping
  * the data that has been transferred via IB RDMA had to be postponed until the
- * check_stop_free() callback.  None of this is nessecary anymore and needs to
+ * check_stop_free() callback.  None of this is necessary anymore and needs to
  * be cleaned up.
  */
 static void srpt_handle_rdma_comp(struct srpt_rdma_ch *ch,
-- 
1.7.12.rc2.9.ge5acacf


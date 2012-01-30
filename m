Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851Ab2A3V0T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 16:26:19 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:56325 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753379Ab2A3V0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 16:26:03 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of autifk@gmail.com designates 10.224.197.5 as permitted sender) smtp.mail=autifk@gmail.com; dkim=pass header.i=autifk@gmail.com
From: Autif Khan <autifk@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>,
        edwin_rong <edwin_rong@realsil.com.cn>,
        Devendra Naga <devendra.aaru@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Autif Khan <autfk@gmail.com>
Subject: [PATCH 1/1] staging: rts5139: Fixed coding style issues
Date: Mon, 30 Jan 2012 16:25:54 -0500
Message-Id: <1327958754-10284-1-git-send-email-autfk@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Autif Khan <autfk@gmail.com>
---
 drivers/staging/rts5139/ms.h               |    4 ++--
 drivers/staging/rts5139/rts51x_chip.h      |    6 +++---
 drivers/staging/rts5139/rts51x_fop.h       |    2 +-
 drivers/staging/rts5139/rts51x_transport.c |    2 +-
 drivers/staging/rts5139/rts51x_transport.h |    2 +-
 drivers/staging/rts5139/sd_cprm.c          |    2 +-
 6 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/rts5139/ms.h b/drivers/staging/rts5139/ms.h
index f9d46d2..3ce1dc9 100644
--- a/drivers/staging/rts5139/ms.h
+++ b/drivers/staging/rts5139/ms.h
@@ -249,9 +249,9 @@ int ms_delay_write(struct rts51x_chip *chip);
 #ifdef SUPPORT_MAGIC_GATE
 
 int ms_switch_clock(struct rts51x_chip *chip);
-int ms_write_bytes(struct rts51x_chip *chip, u8 tpc, u8 cnt, u8 cfg, u8 * data,
+int ms_write_bytes(struct rts51x_chip *chip, u8 tpc, u8 cnt, u8 cfg, u8 *data,
 		   int data_len);
-int ms_read_bytes(struct rts51x_chip *chip, u8 tpc, u8 cnt, u8 cfg, u8 * data,
+int ms_read_bytes(struct rts51x_chip *chip, u8 tpc, u8 cnt, u8 cfg, u8 *data,
 		  int data_len);
 int ms_set_rw_reg_addr(struct rts51x_chip *chip, u8 read_start, u8 read_cnt,
 		       u8 write_start, u8 write_cnt);
diff --git a/drivers/staging/rts5139/rts51x_chip.h b/drivers/staging/rts5139/rts51x_chip.h
index 321ece7..13fc2a4 100644
--- a/drivers/staging/rts5139/rts51x_chip.h
+++ b/drivers/staging/rts5139/rts51x_chip.h
@@ -857,12 +857,12 @@ static inline u8 *rts51x_get_rsp_data(struct rts51x_chip *chip)
 	return chip->rsp_buf;
 }
 
-int rts51x_get_card_status(struct rts51x_chip *chip, u16 * status);
+int rts51x_get_card_status(struct rts51x_chip *chip, u16 *status);
 int rts51x_write_register(struct rts51x_chip *chip, u16 addr, u8 mask, u8 data);
-int rts51x_read_register(struct rts51x_chip *chip, u16 addr, u8 * data);
+int rts51x_read_register(struct rts51x_chip *chip, u16 addr, u8 *data);
 int rts51x_ep0_write_register(struct rts51x_chip *chip, u16 addr, u8 mask,
 			      u8 data);
-int rts51x_ep0_read_register(struct rts51x_chip *chip, u16 addr, u8 * data);
+int rts51x_ep0_read_register(struct rts51x_chip *chip, u16 addr, u8 *data);
 int rts51x_seq_write_register(struct rts51x_chip *chip, u16 addr, u16 len,
 			      u8 *data);
 int rts51x_seq_read_register(struct rts51x_chip *chip, u16 addr, u16 len,
diff --git a/drivers/staging/rts5139/rts51x_fop.h b/drivers/staging/rts5139/rts51x_fop.h
index 0453f57..94d75f0 100644
--- a/drivers/staging/rts5139/rts51x_fop.h
+++ b/drivers/staging/rts5139/rts51x_fop.h
@@ -48,7 +48,7 @@ int rts51x_open(struct inode *inode, struct file *filp);
 int rts51x_release(struct inode *inode, struct file *filp);
 ssize_t rts51x_read(struct file *filp, char __user *buf, size_t count,
 		    loff_t *f_pos);
-ssize_t rts51x_write(struct file *filp, const char __user * buf, size_t count,
+ssize_t rts51x_write(struct file *filp, const char __user *buf, size_t count,
 		     loff_t *f_pos);
 #if 0 /* LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 36) */
 int rts51x_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
diff --git a/drivers/staging/rts5139/rts51x_transport.c b/drivers/staging/rts5139/rts51x_transport.c
index e11467a..da9c83b 100644
--- a/drivers/staging/rts5139/rts51x_transport.c
+++ b/drivers/staging/rts5139/rts51x_transport.c
@@ -883,7 +883,7 @@ int rts51x_transfer_data_partial(struct rts51x_chip *chip, unsigned int pipe,
 	return result;
 }
 
-int rts51x_get_epc_status(struct rts51x_chip *chip, u16 * status)
+int rts51x_get_epc_status(struct rts51x_chip *chip, u16 *status)
 {
 	unsigned int pipe = RCV_INTR_PIPE(chip);
 	struct usb_host_endpoint *ep;
diff --git a/drivers/staging/rts5139/rts51x_transport.h b/drivers/staging/rts5139/rts51x_transport.h
index 8464c48..9dd556e 100644
--- a/drivers/staging/rts5139/rts51x_transport.h
+++ b/drivers/staging/rts5139/rts51x_transport.h
@@ -73,7 +73,7 @@ int rts51x_start_epc_transfer(struct rts51x_chip *chip);
 void rts51x_cancel_epc_transfer(struct rts51x_chip *chip);
 #endif
 
-int rts51x_get_epc_status(struct rts51x_chip *chip, u16 * status);
+int rts51x_get_epc_status(struct rts51x_chip *chip, u16 *status);
 void rts51x_invoke_transport(struct scsi_cmnd *srb, struct rts51x_chip *chip);
 
 #endif /* __RTS51X_TRANSPORT_H */
diff --git a/drivers/staging/rts5139/sd_cprm.c b/drivers/staging/rts5139/sd_cprm.c
index 407cd43..d5969d9 100644
--- a/drivers/staging/rts5139/sd_cprm.c
+++ b/drivers/staging/rts5139/sd_cprm.c
@@ -233,7 +233,7 @@ RTY_SEND_CMD:
 	return STATUS_SUCCESS;
 }
 
-int ext_sd_get_rsp(struct rts51x_chip *chip, int len, u8 * rsp, u8 rsp_type)
+int ext_sd_get_rsp(struct rts51x_chip *chip, int len, u8 *rsp, u8 rsp_type)
 {
 	int retval, rsp_len;
 	u16 reg_addr;
-- 
1.7.4.1


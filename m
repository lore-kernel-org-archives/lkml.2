Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752567Ab2AVVs1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 16:48:27 -0500
Received: from relay01.digicable.hu ([92.249.128.189]:53860 "EHLO
	relay01.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463Ab2AVVs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 16:48:26 -0500
Message-ID: <4F1C83E3.7090901@freemail.hu>
Date: Sun, 22 Jan 2012 22:47:15 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Edwin Rong <edwin_rong@realsil.com.cn>, wwang <wei_wang@realsil.com.cn>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Devendra Naga <devendra.aaru@gmail.com>, devel@driverdev.osuosl.org
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] rts5139: fix pointer coding style
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Original: 84.236.110.113
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

This will remove the following checkpatch.pl error:
ERROR: "foo * bar" should be "foo *bar"

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
 drivers/staging/rts5139/ms.h               |    4 ++--
 drivers/staging/rts5139/rts51x_chip.c      |   14 +++++++-------
 drivers/staging/rts5139/rts51x_chip.h      |    6 +++---
 drivers/staging/rts5139/rts51x_fop.h       |    2 +-
 drivers/staging/rts5139/rts51x_transport.c |    2 +-
 drivers/staging/rts5139/rts51x_transport.h |    2 +-
 drivers/staging/rts5139/sd_cprm.c          |    2 +-
 7 files changed, 16 insertions(+), 16 deletions(-)

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
diff --git a/drivers/staging/rts5139/rts51x_chip.c b/drivers/staging/rts5139/rts51x_chip.c
index adc0d00..b3e0bb2 100644
--- a/drivers/staging/rts5139/rts51x_chip.c
+++ b/drivers/staging/rts5139/rts51x_chip.c
@@ -541,7 +541,7 @@ int rts51x_get_rsp(struct rts51x_chip *chip, int rsp_len, int timeout)
 	return STATUS_SUCCESS;
 }

-int rts51x_get_card_status(struct rts51x_chip *chip, u16 * status)
+int rts51x_get_card_status(struct rts51x_chip *chip, u16 *status)
 {
 	int retval;
 	u16 val;
@@ -577,7 +577,7 @@ int rts51x_write_register(struct rts51x_chip *chip, u16 addr, u8 mask, u8 data)
 	return STATUS_SUCCESS;
 }

-int rts51x_read_register(struct rts51x_chip *chip, u16 addr, u8 * data)
+int rts51x_read_register(struct rts51x_chip *chip, u16 addr, u8 *data)
 {
 	int retval;

@@ -620,7 +620,7 @@ int rts51x_ep0_write_register(struct rts51x_chip *chip, u16 addr, u8 mask,
 	return STATUS_SUCCESS;
 }

-int rts51x_ep0_read_register(struct rts51x_chip *chip, u16 addr, u8 * data)
+int rts51x_ep0_read_register(struct rts51x_chip *chip, u16 addr, u8 *data)
 {
 	int retval;
 	u16 value = 0;
@@ -720,7 +720,7 @@ int rts51x_seq_read_register(struct rts51x_chip *chip, u16 addr, u16 len,
 	return STATUS_SUCCESS;
 }

-int rts51x_read_ppbuf(struct rts51x_chip *chip, u8 * buf, int buf_len)
+int rts51x_read_ppbuf(struct rts51x_chip *chip, u8 *buf, int buf_len)
 {
 	int retval;

@@ -735,7 +735,7 @@ int rts51x_read_ppbuf(struct rts51x_chip *chip, u8 * buf, int buf_len)
 	return STATUS_SUCCESS;
 }

-int rts51x_write_ppbuf(struct rts51x_chip *chip, u8 * buf, int buf_len)
+int rts51x_write_ppbuf(struct rts51x_chip *chip, u8 *buf, int buf_len)
 {
 	int retval;

@@ -776,7 +776,7 @@ int rts51x_write_phy_register(struct rts51x_chip *chip, u8 addr, u8 val)
 	return STATUS_SUCCESS;
 }

-int rts51x_read_phy_register(struct rts51x_chip *chip, u8 addr, u8 * val)
+int rts51x_read_phy_register(struct rts51x_chip *chip, u8 addr, u8 *val)
 {
 	int retval;

@@ -921,7 +921,7 @@ void rts51x_trace_msg(struct rts51x_chip *chip, unsigned char *buf, int clear)
 }
 #endif

-void rts51x_pp_status(struct rts51x_chip *chip, unsigned int lun, u8 * status,
+void rts51x_pp_status(struct rts51x_chip *chip, unsigned int lun, u8 *status,
 		      u8 status_len)
 {
 	struct sd_info *sd_card = &(chip->sd_card);
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
1.7.2.5


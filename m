Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966589Ab2EOTcx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 15:32:53 -0400
Received: from nm22-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.222]:40766 "HELO
	nm22-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S966555Ab2EOTcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 15:32:52 -0400
X-Yahoo-Newman-Id: 707408.4985.bm@smtp220.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: gPcm0S8VM1mnC6bF1kuoOZjiUd.ax.4mu7NHaeVK245Jwuh
 NDuS7HqcyjEIVo1Kg_S7hMjpqXk4QXr1buHk_2Lxl5YrEoN.KP3js3GuMZqM
 i6.B5nzQ3gSoTemBXh6LjGXKgU_Le.cJCl2vz5ffycUj25yvEzlhM1CInmS7
 GIjBdb4Jxzey74s8achV0H6JP8CfSxoasajQbaf_Rc7vegT5cvs0yEzAMffs
 cj9Mbt_32_gE09vi5ktHebSCfX6GPSu_ZrMWYx1WhWigT22bO5K_WqfmDzh8
 Cjc0O_3Lcl7sFbMiMQp8I2iaKl2dUznk2QmlkCyn6.B18DdBaCDsWGhBQpgh
 uHXAcbmkPFdCxkwG66h7uj9L2UmiwOU42DrNd.TxblZ5M3m8_cVHKIB9dGu.
 XJPRiCjM9zWpy7_ljtVpFxgT8CB3ozdXXOEJwpNu2qpCbkIHnsv9cFON4FYO
 sq04gUM3CbVI6xVGBrUyNVIg6Dud78jLA.V6tynMi6I_npJV73w5Gp_ntnQ-
 -
X-Yahoo-SMTP: dNW5aIGswBCf1iV6QK8RWrBgWyjShXs-
From: Jeffrin Jose <ahiliation@yahoo.co.in>
To: mdharm-usb@one-eyed-alien.net, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, ahiliation@yahoo.co.in
Subject: [PATCH 2/3] drivers:Fixed several trailing white spaces issues.
Date: Wed, 16 May 2012 01:06:04 +0530
Message-Id: <1337110565-9843-1-git-send-email-ahiliation@yahoo.co.in>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed several trailing white spaces issues found
by checkpatch.pl tool in drivers/usb/storage/usb.c
Signed-off-by: Jeffrin Jose <ahiliation@yahoo.co.in>
---
 drivers/usb/storage/usb.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
index 7ad1a8b..16d49da 100644
--- a/drivers/usb/storage/usb.c
+++ b/drivers/usb/storage/usb.c
@@ -121,7 +121,7 @@ MODULE_PARM_DESC(quirks, "supplemental list of device IDs and their quirks");
 }
 
 static struct us_unusual_dev us_unusual_dev_list[] = {
-#	include "unusual_devs.h" 
+#	include "unusual_devs.h"
 	{ }		/* Terminating entry */
 };
 
@@ -261,7 +261,7 @@ EXPORT_SYMBOL_GPL(usb_stor_post_reset);
 void fill_inquiry_response(struct us_data *us, unsigned char *data,
 		unsigned int data_len)
 {
-	if (data_len<36) /* You lose. */
+	if (data_len < 36) /* You lose. */
 		return;
 
 	memset(data+8, ' ', 28);
@@ -271,7 +271,7 @@ void fill_inquiry_response(struct us_data *us, unsigned char *data,
 			      to this logical unit") and leave vendor and
 			      product identification empty. ("If the target
 			      does store some of the INQUIRY data on the
-			      device, it may return zeros or ASCII spaces 
+			      device, it may return zeros or ASCII spaces
 			      (20h) in those fields until the data is
 			      available from the device."). */
 	} else {
@@ -327,7 +327,7 @@ static int usb_stor_control_thread(void * __us)
 
 		scsi_unlock(host);
 
-		/* reject the command if the direction indicator 
+		/* reject the command if the direction indicator
 		 * is UNKNOWN
 		 */
 		if (us->srb->sc_data_direction == DMA_BIDIRECTIONAL) {
@@ -338,7 +338,7 @@ static int usb_stor_control_thread(void * __us)
 		/* reject if target != 0 or if LUN is higher than
 		 * the maximum known LUN
 		 */
-		else if (us->srb->device->id && 
+		else if (us->srb->device->id &&
 				!(us->fflags & US_FL_SCM_MULT_TARG)) {
 			US_DEBUGP("Bad target number (%d:%d)\n",
 				  us->srb->device->id, us->srb->device->lun);
@@ -351,7 +351,7 @@ static int usb_stor_control_thread(void * __us)
 			us->srb->result = DID_BAD_TARGET << 16;
 		}
 
-		/* Handle those devices which need us to fake 
+		/* Handle those devices which need us to fake
 		 * their inquiry data */
 		else if ((us->srb->cmnd[0] == INQUIRY) &&
 			    (us->fflags & US_FL_FIX_INQUIRY)) {
@@ -376,7 +376,7 @@ static int usb_stor_control_thread(void * __us)
 
 		/* indicate that the command is done */
 		if (us->srb->result != DID_ABORT << 16) {
-			US_DEBUGP("scsi cmd done, result=0x%x\n", 
+			US_DEBUGP("scsi cmd done, result=0x%x\n",
 				   us->srb->result);
 			us->srb->scsi_done(us->srb);
 		} else {
@@ -414,7 +414,7 @@ SkipForAbort:
 	}
 	__set_current_state(TASK_RUNNING);
 	return 0;
-}	
+}
 
 /***********************************************************************
  * Device probing and disconnecting
@@ -732,7 +732,7 @@ static int get_pipes(struct us_data *us)
 	us->recv_ctrl_pipe = usb_rcvctrlpipe(us->pusb_dev, 0);
 	us->send_bulk_pipe = usb_sndbulkpipe(us->pusb_dev,
 		usb_endpoint_num(ep_out));
-	us->recv_bulk_pipe = usb_rcvbulkpipe(us->pusb_dev, 
+	us->recv_bulk_pipe = usb_rcvbulkpipe(us->pusb_dev,
 		usb_endpoint_num(ep_in));
 	if (ep_int) {
 		us->recv_intr_pipe = usb_rcvintpipe(us->pusb_dev,
-- 
1.7.10


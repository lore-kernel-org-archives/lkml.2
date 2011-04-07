Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086Ab1DGQJq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 12:09:46 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:52387 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755664Ab1DGQJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 12:09:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=l+QSDV8DDCzu6hLAzDMC9VfaZJTHOprvHiYXbEpFT5TQ4YJu3cwUpc/9VNYv/xZd8x
         cTrRQJyrkWMyllv9quPZ4EN4RPuRK+EoJkweb0fH5fSgU0h/tdYgA0uN2Y63rgIMr0vl
         zcymqIT4kBCYaIHAWc88cI4SgBwvNZ70wFyAo=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [RFC 2/6]Fix typo "recieve" in various parts of the kernel.
Date: Thu,  7 Apr 2011 09:09:23 -0700
Message-Id: <1302192567-842-2-git-send-email-justinmattock@gmail.com>
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
 Documentation/networking/caif/spi_porting.txt |    2 +-
 Documentation/scsi/ChangeLog.lpfc             |    2 +-
 arch/arm/mach-sa1100/jornada720_ssp.c         |    2 +-
 arch/arm/plat-omap/mcbsp.c                    |    2 +-
 drivers/dma/intel_mid_dma_regs.h              |    4 ++--
 drivers/gpu/drm/nouveau/nv40_graph.c          |    2 +-
 drivers/input/mouse/bcm5974.c                 |    2 +-
 drivers/media/dvb/frontends/s5h1420.c         |    2 +-
 drivers/media/dvb/pluto2/pluto2.c             |    2 +-
 drivers/media/dvb/ttusb-dec/ttusb_dec.c       |    2 +-
 drivers/memstick/host/r592.h                  |    4 ++--
 drivers/misc/kgdbts.c                         |    2 +-
 drivers/net/caif/caif_spi_slave.c             |    2 +-
 drivers/net/davinci_emac.c                    |    2 +-
 drivers/net/natsemi.c                         |    2 +-
 15 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/Documentation/networking/caif/spi_porting.txt b/Documentation/networking/caif/spi_porting.txt
index 0cb8cb9..9efd068 100644
--- a/Documentation/networking/caif/spi_porting.txt
+++ b/Documentation/networking/caif/spi_porting.txt
@@ -150,7 +150,7 @@ static int sspi_init_xfer(struct cfspi_xfer *xfer, struct cfspi_dev *dev)
 void sspi_sig_xfer(bool xfer, struct cfspi_dev *dev)
 {
 	/* If xfer is true then you should assert the SPI_INT to indicate to
-	 * the master that you are ready to recieve the data from the master
+	 * the master that you are ready to receive the data from the master
 	 * SPI. If xfer is false then you should de-assert SPI_INT to indicate
 	 * that the transfer is done.
 	 */
diff --git a/Documentation/scsi/ChangeLog.lpfc b/Documentation/scsi/ChangeLog.lpfc
index 5e83769..e096e19 100644
--- a/Documentation/scsi/ChangeLog.lpfc
+++ b/Documentation/scsi/ChangeLog.lpfc
@@ -352,7 +352,7 @@ Changes from 20041229 to 20050110
 	  lpfc_scsiport.c
 	* In remote port changes: no longer nulling target->pnode when
 	  removing from mapped list. Pnode get nulled when the node is
-	  freed (after nodev tmo). This bug was causing i/o recieved in
+	  freed (after nodev tmo). This bug was causing i/o received in
 	  the small window while the device was blocked to be errored w/
 	  did_no_connect. With the fix, it returns host_busy
 	  (per the pre-remote port changes).
diff --git a/arch/arm/mach-sa1100/jornada720_ssp.c b/arch/arm/mach-sa1100/jornada720_ssp.c
index 9d490c6..dea6e03 100644
--- a/arch/arm/mach-sa1100/jornada720_ssp.c
+++ b/arch/arm/mach-sa1100/jornada720_ssp.c
@@ -29,7 +29,7 @@ static unsigned long jornada_ssp_flags;
 /**
  * jornada_ssp_reverse - reverses input byte
  *
- * we need to reverse all data we recieve from the mcu due to its physical location
+ * we need to reverse all data we receive from the mcu due to its physical location
  * returns : 01110111 -> 11101110
  */
 u8 inline jornada_ssp_reverse(u8 byte)
diff --git a/arch/arm/plat-omap/mcbsp.c b/arch/arm/plat-omap/mcbsp.c
index d598d9f..5587acf 100644
--- a/arch/arm/plat-omap/mcbsp.c
+++ b/arch/arm/plat-omap/mcbsp.c
@@ -1103,7 +1103,7 @@ int omap_mcbsp_pollread(unsigned int id, u16 *buf)
 		/* resend */
 		return -1;
 	} else {
-		/* wait for recieve confirmation */
+		/* wait for receive confirmation */
 		int attemps = 0;
 		while (!(MCBSP_READ(mcbsp, SPCR1) & RRDY)) {
 			if (attemps++ > 1000) {
diff --git a/drivers/dma/intel_mid_dma_regs.h b/drivers/dma/intel_mid_dma_regs.h
index 709fecb..aea5ee8 100644
--- a/drivers/dma/intel_mid_dma_regs.h
+++ b/drivers/dma/intel_mid_dma_regs.h
@@ -174,8 +174,8 @@ union intel_mid_dma_cfg_hi {
  * @dma: dma device struture pointer
  * @busy: bool representing if ch is busy (active txn) or not
  * @in_use: bool representing if ch is in use or not
- * @raw_tfr: raw trf interrupt recieved
- * @raw_block: raw block interrupt recieved
+ * @raw_tfr: raw trf interrupt received
+ * @raw_block: raw block interrupt received
  */
 struct intel_mid_dma_chan {
 	struct dma_chan		chan;
diff --git a/drivers/gpu/drm/nouveau/nv40_graph.c b/drivers/gpu/drm/nouveau/nv40_graph.c
index 18d30c2..fceb44c 100644
--- a/drivers/gpu/drm/nouveau/nv40_graph.c
+++ b/drivers/gpu/drm/nouveau/nv40_graph.c
@@ -181,7 +181,7 @@ nv40_graph_load_context(struct nouveau_channel *chan)
 		  NV40_PGRAPH_CTXCTL_CUR_LOADED);
 	/* 0x32E0 records the instance address of the active FIFO's PGRAPH
 	 * context.  If at any time this doesn't match 0x40032C, you will
-	 * recieve PGRAPH_INTR_CONTEXT_SWITCH
+	 * receive PGRAPH_INTR_CONTEXT_SWITCH
 	 */
 	nv_wr32(dev, NV40_PFIFO_GRCTX_INSTANCE, inst);
 	return 0;
diff --git a/drivers/input/mouse/bcm5974.c b/drivers/input/mouse/bcm5974.c
index 3aead91..3126983 100644
--- a/drivers/input/mouse/bcm5974.c
+++ b/drivers/input/mouse/bcm5974.c
@@ -639,7 +639,7 @@ exit:
  * device, resulting in trackpad malfunction under certain
  * circumstances. To get around this problem, there is at least one
  * example that utilizes the USB_QUIRK_RESET_RESUME quirk in order to
- * recieve a reset_resume request rather than the normal resume.
+ * receive a reset_resume request rather than the normal resume.
  * Since the implementation of reset_resume is equal to mode switch
  * plus start_traffic, it seems easier to always do the switch when
  * starting traffic on the device.
diff --git a/drivers/media/dvb/frontends/s5h1420.c b/drivers/media/dvb/frontends/s5h1420.c
index e87b747..17f8cdf 100644
--- a/drivers/media/dvb/frontends/s5h1420.c
+++ b/drivers/media/dvb/frontends/s5h1420.c
@@ -225,7 +225,7 @@ static int s5h1420_recv_slave_reply (struct dvb_frontend* fe,
 	unsigned long timeout;
 	int result = 0;
 
-	/* setup for DISEQC recieve */
+	/* setup for DISEQC receive */
 	val = s5h1420_readreg(state, 0x3b);
 	s5h1420_writereg(state, 0x3b, 0x82); /* FIXME: guess - do we need to set DIS_RDY(0x08) in receive mode? */
 	msleep(15);
diff --git a/drivers/media/dvb/pluto2/pluto2.c b/drivers/media/dvb/pluto2/pluto2.c
index 6ca6713..5993e8c 100644
--- a/drivers/media/dvb/pluto2/pluto2.c
+++ b/drivers/media/dvb/pluto2/pluto2.c
@@ -299,7 +299,7 @@ static void pluto_dma_end(struct pluto *pluto, unsigned int nbpackets)
 	 *     although one packet has been transfered.
 	 * [3] Sometimes (actually rarely), the card gets into an erroneous
 	 *     mode where it continuously generates interrupts, claiming it
-	 *     has recieved nbpackets>TS_DMA_PACKETS packets, but no packet
+	 *     has received nbpackets>TS_DMA_PACKETS packets, but no packet
 	 *     has been transfered. Only a reset seems to solve this
 	 */
 	if ((nbpackets == 0) || (nbpackets > TS_DMA_PACKETS)) {
diff --git a/drivers/media/dvb/ttusb-dec/ttusb_dec.c b/drivers/media/dvb/ttusb-dec/ttusb_dec.c
index fe1b803..f893bff 100644
--- a/drivers/media/dvb/ttusb-dec/ttusb_dec.c
+++ b/drivers/media/dvb/ttusb-dec/ttusb_dec.c
@@ -234,7 +234,7 @@ static void ttusb_dec_handle_irq( struct urb *urb)
 		 * (with buffer[3] == 0x40) in an intervall of ~100ms.
 		 * But to handle this correctly we had to imlemenent some
 		 * kind of timer which signals a 'key up' event if no
-		 * keyrepeat signal is recieved for lets say 200ms.
+		 * keyrepeat signal is received for lets say 200ms.
 		 * this should/could be added later ...
 		 * for now lets report each signal as a key down and up*/
 		dprintk("%s:rc signal:%d\n", __func__, buffer[4]);
diff --git a/drivers/memstick/host/r592.h b/drivers/memstick/host/r592.h
index eee264e..b5a3063 100644
--- a/drivers/memstick/host/r592.h
+++ b/drivers/memstick/host/r592.h
@@ -46,9 +46,9 @@
 #define R592_STATUS_RECV_ERR		(1 << 25)	/* Recieve failed */
 
 							/* Card state */
-#define R592_STATUS_RDY			(1 << 28)	/* RDY signal recieved */
+#define R592_STATUS_RDY			(1 << 28)	/* RDY signal received */
 #define R592_STATUS_CED			(1 << 29)	/* INT: Command done (serial mode)*/
-#define R592_STATUS_SFIFO_INPUT		(1 << 30)	/* Small fifo recieved data*/
+#define R592_STATUS_SFIFO_INPUT		(1 << 30)	/* Small fifo received data*/
 
 #define R592_SFIFO_SIZE			32		/* total size of small fifo is 32 bytes */
 #define R592_SFIFO_PACKET		8		/* packet size of small fifo */
diff --git a/drivers/misc/kgdbts.c b/drivers/misc/kgdbts.c
index 27dc463..74f16f1 100644
--- a/drivers/misc/kgdbts.c
+++ b/drivers/misc/kgdbts.c
@@ -645,7 +645,7 @@ static int validate_simple_test(char *put_str)
 
 	while (*chk_str != '\0' && *put_str != '\0') {
 		/* If someone does a * to match the rest of the string, allow
-		 * it, or stop if the recieved string is complete.
+		 * it, or stop if the received string is complete.
 		 */
 		if (*put_str == '#' || *chk_str == '*')
 			return 0;
diff --git a/drivers/net/caif/caif_spi_slave.c b/drivers/net/caif/caif_spi_slave.c
index 1b9943a..9fee8e3 100644
--- a/drivers/net/caif/caif_spi_slave.c
+++ b/drivers/net/caif/caif_spi_slave.c
@@ -158,7 +158,7 @@ void cfspi_xfer(struct work_struct *work)
 
 		cfspi_dbg_state(cfspi, CFSPI_STATE_SIG_ACTIVE);
 
-		/* Signal that we are ready to recieve data. */
+		/* Signal that we are ready to receive data. */
 		cfspi->dev->sig_xfer(true, cfspi->dev);
 
 		cfspi_dbg_state(cfspi, CFSPI_STATE_WAIT_XFER_DONE);
diff --git a/drivers/net/davinci_emac.c b/drivers/net/davinci_emac.c
index baca6bf..1e1859b 100644
--- a/drivers/net/davinci_emac.c
+++ b/drivers/net/davinci_emac.c
@@ -1013,7 +1013,7 @@ static void emac_rx_handler(void *token, int len, int status)
 		return;
 	}
 
-	/* recycle on recieve error */
+	/* recycle on receive error */
 	if (status < 0) {
 		ndev->stats.rx_errors++;
 		goto recycle;
diff --git a/drivers/net/natsemi.c b/drivers/net/natsemi.c
index 2fd3963..ae8067d 100644
--- a/drivers/net/natsemi.c
+++ b/drivers/net/natsemi.c
@@ -203,7 +203,7 @@ skbuff at an offset of "+2", 16-byte aligning the IP header.
 IIId. Synchronization
 
 Most operations are synchronized on the np->lock irq spinlock, except the
-recieve and transmit paths which are synchronised using a combination of
+receive and transmit paths which are synchronised using a combination of
 hardware descriptor ownership, disabling interrupts and NAPI poll scheduling.
 
 IVb. References
-- 
1.7.4.2


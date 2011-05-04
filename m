Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923Ab1EDC3a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 22:29:30 -0400
Received: from mail.perches.com ([173.55.12.10]:1227 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754652Ab1EDC3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 22:29:05 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Linux PCMCIA team <linux-pcmcia@lists.infradead.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [TRIVIAL PATCH 2/3] pcmcia: Convert pcmcia_device_id declarations to const
Date: Tue,  3 May 2011 19:29:01 -0700
Message-Id: <3a2eaa60387e1d5c370a09222930ad27acfb7514.1304475548.git.joe@perches.com>
X-Mailer: git-send-email 1.7.5.rc3.dirty
In-Reply-To: <cover.1304475547.git.joe@perches.com>
References: <cover.1304475547.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Saves about 50KB of data.

Old/new size of all objects:
   text	   data	    bss	    dec	    hex	filename
 563015	  80096	 130684	 773795	  bcea3	(TOTALS)
 610916	  32256	 130632	 773804	  bceac	(TOTALS)

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/ata/pata_pcmcia.c                  |    2 +-
 drivers/bluetooth/bluecard_cs.c            |    2 +-
 drivers/bluetooth/bt3c_cs.c                |    2 +-
 drivers/bluetooth/btuart_cs.c              |    2 +-
 drivers/bluetooth/dtl1_cs.c                |    2 +-
 drivers/char/pcmcia/cm4000_cs.c            |    2 +-
 drivers/char/pcmcia/cm4040_cs.c            |    2 +-
 drivers/char/pcmcia/synclink_cs.c          |    2 +-
 drivers/ide/ide-cs.c                       |    2 +-
 drivers/isdn/hardware/avm/avm_cs.c         |    2 +-
 drivers/isdn/hisax/avma1_cs.c              |    2 +-
 drivers/isdn/hisax/elsa_cs.c               |    2 +-
 drivers/isdn/hisax/sedlbauer_cs.c          |    2 +-
 drivers/isdn/hisax/teles_cs.c              |    2 +-
 drivers/mmc/host/sdricoh_cs.c              |    2 +-
 drivers/mtd/maps/pcmciamtd.c               |    2 +-
 drivers/net/can/softing/softing_cs.c       |    2 +-
 drivers/net/pcmcia/3c574_cs.c              |    2 +-
 drivers/net/pcmcia/3c589_cs.c              |    2 +-
 drivers/net/pcmcia/axnet_cs.c              |    2 +-
 drivers/net/pcmcia/com20020_cs.c           |    2 +-
 drivers/net/pcmcia/fmvj18x_cs.c            |    2 +-
 drivers/net/pcmcia/ibmtr_cs.c              |    2 +-
 drivers/net/pcmcia/nmclan_cs.c             |    2 +-
 drivers/net/pcmcia/pcnet_cs.c              |    2 +-
 drivers/net/pcmcia/smc91c92_cs.c           |    2 +-
 drivers/net/pcmcia/xirc2ps_cs.c            |    2 +-
 drivers/net/wireless/airo_cs.c             |    2 +-
 drivers/net/wireless/atmel_cs.c            |    4 ++--
 drivers/net/wireless/b43/pcmcia.c          |    2 +-
 drivers/net/wireless/hostap/hostap_cs.c    |    2 +-
 drivers/net/wireless/libertas/if_cs.c      |    2 +-
 drivers/net/wireless/orinoco/orinoco_cs.c  |    2 +-
 drivers/net/wireless/orinoco/spectrum_cs.c |    2 +-
 drivers/net/wireless/ray_cs.c              |    2 +-
 drivers/net/wireless/wl3501_cs.c           |    2 +-
 drivers/parport/parport_cs.c               |    2 +-
 drivers/scsi/pcmcia/aha152x_stub.c         |    2 +-
 drivers/scsi/pcmcia/fdomain_stub.c         |    2 +-
 drivers/scsi/pcmcia/nsp_cs.c               |    2 +-
 drivers/scsi/pcmcia/qlogic_stub.c          |    2 +-
 drivers/scsi/pcmcia/sym53c500_cs.c         |    2 +-
 drivers/telephony/ixj_pcmcia.c             |    2 +-
 drivers/tty/ipwireless/main.c              |    2 +-
 drivers/tty/serial/serial_cs.c             |    2 +-
 drivers/usb/host/sl811_cs.c                |    2 +-
 46 files changed, 47 insertions(+), 47 deletions(-)

diff --git a/drivers/ata/pata_pcmcia.c b/drivers/ata/pata_pcmcia.c
index 29af660..021abe6 100644
--- a/drivers/ata/pata_pcmcia.c
+++ b/drivers/ata/pata_pcmcia.c
@@ -309,7 +309,7 @@ static void pcmcia_remove_one(struct pcmcia_device *pdev)
 	pcmcia_disable_device(pdev);
 }
 
-static struct pcmcia_device_id pcmcia_devices[] = {
+static const struct pcmcia_device_id pcmcia_devices[] = {
 	PCMCIA_DEVICE_FUNC_ID(4),
 	PCMCIA_DEVICE_MANF_CARD(0x0000, 0x0000),	/* Corsair */
 	PCMCIA_DEVICE_MANF_CARD(0x0007, 0x0000),	/* Hitachi */
diff --git a/drivers/bluetooth/bluecard_cs.c b/drivers/bluetooth/bluecard_cs.c
index 4104b7f..aed1904 100644
--- a/drivers/bluetooth/bluecard_cs.c
+++ b/drivers/bluetooth/bluecard_cs.c
@@ -930,7 +930,7 @@ static void bluecard_release(struct pcmcia_device *link)
 	pcmcia_disable_device(link);
 }
 
-static struct pcmcia_device_id bluecard_ids[] = {
+static const struct pcmcia_device_id bluecard_ids[] = {
 	PCMCIA_DEVICE_PROD_ID12("BlueCard", "LSE041", 0xbaf16fbf, 0x657cc15e),
 	PCMCIA_DEVICE_PROD_ID12("BTCFCARD", "LSE139", 0xe3987764, 0x2524b59c),
 	PCMCIA_DEVICE_PROD_ID12("WSS", "LSE039", 0x0a0736ec, 0x24e6dfab),
diff --git a/drivers/bluetooth/bt3c_cs.c b/drivers/bluetooth/bt3c_cs.c
index 0c8a655..4fc0194 100644
--- a/drivers/bluetooth/bt3c_cs.c
+++ b/drivers/bluetooth/bt3c_cs.c
@@ -761,7 +761,7 @@ static void bt3c_release(struct pcmcia_device *link)
 }
 
 
-static struct pcmcia_device_id bt3c_ids[] = {
+static const struct pcmcia_device_id bt3c_ids[] = {
 	PCMCIA_DEVICE_PROD_ID13("3COM", "Bluetooth PC Card", 0xefce0a31, 0xd4ce9b02),
 	PCMCIA_DEVICE_NULL
 };
diff --git a/drivers/bluetooth/btuart_cs.c b/drivers/bluetooth/btuart_cs.c
index f8a0708..526b618 100644
--- a/drivers/bluetooth/btuart_cs.c
+++ b/drivers/bluetooth/btuart_cs.c
@@ -689,7 +689,7 @@ static void btuart_release(struct pcmcia_device *link)
 	pcmcia_disable_device(link);
 }
 
-static struct pcmcia_device_id btuart_ids[] = {
+static const struct pcmcia_device_id btuart_ids[] = {
 	/* don't use this driver. Use serial_cs + hci_uart instead */
 	PCMCIA_DEVICE_NULL
 };
diff --git a/drivers/bluetooth/dtl1_cs.c b/drivers/bluetooth/dtl1_cs.c
index 26ee0cf..5e4c2de 100644
--- a/drivers/bluetooth/dtl1_cs.c
+++ b/drivers/bluetooth/dtl1_cs.c
@@ -636,7 +636,7 @@ static void dtl1_release(struct pcmcia_device *link)
 }
 
 
-static struct pcmcia_device_id dtl1_ids[] = {
+static const struct pcmcia_device_id dtl1_ids[] = {
 	PCMCIA_DEVICE_PROD_ID12("Nokia Mobile Phones", "DTL-1", 0xe1bfdd64, 0xe168480d),
 	PCMCIA_DEVICE_PROD_ID12("Nokia Mobile Phones", "DTL-4", 0xe1bfdd64, 0x9102bc82),
 	PCMCIA_DEVICE_PROD_ID12("Socket", "CF", 0xb38bcc2e, 0x44ebf863),
diff --git a/drivers/char/pcmcia/cm4000_cs.c b/drivers/char/pcmcia/cm4000_cs.c
index 90bd016..a758486 100644
--- a/drivers/char/pcmcia/cm4000_cs.c
+++ b/drivers/char/pcmcia/cm4000_cs.c
@@ -1869,7 +1869,7 @@ static const struct file_operations cm4000_fops = {
 	.llseek = no_llseek,
 };
 
-static struct pcmcia_device_id cm4000_ids[] = {
+static const struct pcmcia_device_id cm4000_ids[] = {
 	PCMCIA_DEVICE_MANF_CARD(0x0223, 0x0002),
 	PCMCIA_DEVICE_PROD_ID12("CardMan", "4000", 0x2FB368CA, 0xA2BD8C39),
 	PCMCIA_DEVICE_NULL,
diff --git a/drivers/char/pcmcia/cm4040_cs.c b/drivers/char/pcmcia/cm4040_cs.c
index 5d8d59e..8dd48a2 100644
--- a/drivers/char/pcmcia/cm4040_cs.c
+++ b/drivers/char/pcmcia/cm4040_cs.c
@@ -633,7 +633,7 @@ static const struct file_operations reader_fops = {
 	.llseek		= no_llseek,
 };
 
-static struct pcmcia_device_id cm4040_ids[] = {
+static const struct pcmcia_device_id cm4040_ids[] = {
 	PCMCIA_DEVICE_MANF_CARD(0x0223, 0x0200),
 	PCMCIA_DEVICE_PROD_ID12("OMNIKEY", "CardMan 4040",
 				0xE32CDD8C, 0x8F23318B),
diff --git a/drivers/char/pcmcia/synclink_cs.c b/drivers/char/pcmcia/synclink_cs.c
index b575411..1578139 100644
--- a/drivers/char/pcmcia/synclink_cs.c
+++ b/drivers/char/pcmcia/synclink_cs.c
@@ -2758,7 +2758,7 @@ static void mgslpc_remove_device(MGSLPC_INFO *remove_info)
 	}
 }
 
-static struct pcmcia_device_id mgslpc_ids[] = {
+static const struct pcmcia_device_id mgslpc_ids[] = {
 	PCMCIA_DEVICE_MANF_CARD(0x02c5, 0x0050),
 	PCMCIA_DEVICE_NULL
 };
diff --git a/drivers/ide/ide-cs.c b/drivers/ide/ide-cs.c
index 404843e..d2f3db3 100644
--- a/drivers/ide/ide-cs.c
+++ b/drivers/ide/ide-cs.c
@@ -272,7 +272,7 @@ static void ide_release(struct pcmcia_device *link)
 } /* ide_release */
 
 
-static struct pcmcia_device_id ide_ids[] = {
+static const struct pcmcia_device_id ide_ids[] = {
 	PCMCIA_DEVICE_FUNC_ID(4),
 	PCMCIA_DEVICE_MANF_CARD(0x0000, 0x0000),	/* Corsair */
 	PCMCIA_DEVICE_MANF_CARD(0x0007, 0x0000),	/* Hitachi */
diff --git a/drivers/isdn/hardware/avm/avm_cs.c b/drivers/isdn/hardware/avm/avm_cs.c
index 91f06a3..61f516f 100644
--- a/drivers/isdn/hardware/avm/avm_cs.c
+++ b/drivers/isdn/hardware/avm/avm_cs.c
@@ -149,7 +149,7 @@ static void avmcs_release(struct pcmcia_device *link)
 } /* avmcs_release */
 
 
-static struct pcmcia_device_id avmcs_ids[] = {
+static const struct pcmcia_device_id avmcs_ids[] = {
 	PCMCIA_DEVICE_PROD_ID12("AVM", "ISDN-Controller B1", 0x95d42008, 0x845dc335),
 	PCMCIA_DEVICE_PROD_ID12("AVM", "Mobile ISDN-Controller M1", 0x95d42008, 0x81e10430),
 	PCMCIA_DEVICE_PROD_ID12("AVM", "Mobile ISDN-Controller M2", 0x95d42008, 0x18e8558a),
diff --git a/drivers/isdn/hisax/avma1_cs.c b/drivers/isdn/hisax/avma1_cs.c
index ac4dd78..8f0ad2a 100644
--- a/drivers/isdn/hisax/avma1_cs.c
+++ b/drivers/isdn/hisax/avma1_cs.c
@@ -146,7 +146,7 @@ static void avma1cs_release(struct pcmcia_device *link)
 	pcmcia_disable_device(link);
 } /* avma1cs_release */
 
-static struct pcmcia_device_id avma1cs_ids[] = {
+static const struct pcmcia_device_id avma1cs_ids[] = {
 	PCMCIA_DEVICE_PROD_ID12("AVM", "ISDN A", 0x95d42008, 0xadc9d4bb),
 	PCMCIA_DEVICE_PROD_ID12("ISDN", "CARD", 0x8d9761c8, 0x01c5aa7b),
 	PCMCIA_DEVICE_NULL
diff --git a/drivers/isdn/hisax/elsa_cs.c b/drivers/isdn/hisax/elsa_cs.c
index 9e5e87b..f0b6c0e 100644
--- a/drivers/isdn/hisax/elsa_cs.c
+++ b/drivers/isdn/hisax/elsa_cs.c
@@ -200,7 +200,7 @@ static int elsa_resume(struct pcmcia_device *link)
 	return 0;
 }
 
-static struct pcmcia_device_id elsa_ids[] = {
+static const struct pcmcia_device_id elsa_ids[] = {
 	PCMCIA_DEVICE_PROD_ID12("ELSA AG (Aachen, Germany)", "MicroLink ISDN/MC ", 0x983de2c4, 0x333ba257),
 	PCMCIA_DEVICE_PROD_ID12("ELSA GmbH, Aachen", "MicroLink ISDN/MC ", 0x639e5718, 0x333ba257),
 	PCMCIA_DEVICE_NULL
diff --git a/drivers/isdn/hisax/sedlbauer_cs.c b/drivers/isdn/hisax/sedlbauer_cs.c
index 360204b..06473f8 100644
--- a/drivers/isdn/hisax/sedlbauer_cs.c
+++ b/drivers/isdn/hisax/sedlbauer_cs.c
@@ -186,7 +186,7 @@ static int sedlbauer_resume(struct pcmcia_device *link)
 }
 
 
-static struct pcmcia_device_id sedlbauer_ids[] = {
+static const struct pcmcia_device_id sedlbauer_ids[] = {
 	PCMCIA_DEVICE_PROD_ID123("SEDLBAUER", "speed star II", "V 3.1", 0x81fb79f5, 0xf3612e1d, 0x6b95c78a),
 	PCMCIA_DEVICE_PROD_ID123("SEDLBAUER", "ISDN-Adapter", "4D67", 0x81fb79f5, 0xe4e9bc12, 0x397b7e90),
 	PCMCIA_DEVICE_PROD_ID123("SEDLBAUER", "ISDN-Adapter", "4D98", 0x81fb79f5, 0xe4e9bc12, 0x2e5c7fce),
diff --git a/drivers/isdn/hisax/teles_cs.c b/drivers/isdn/hisax/teles_cs.c
index 360f9ec..161a193 100644
--- a/drivers/isdn/hisax/teles_cs.c
+++ b/drivers/isdn/hisax/teles_cs.c
@@ -183,7 +183,7 @@ static int teles_resume(struct pcmcia_device *link)
 }
 
 
-static struct pcmcia_device_id teles_ids[] = {
+static const struct pcmcia_device_id teles_ids[] = {
 	PCMCIA_DEVICE_PROD_ID12("TELES", "S0/PC", 0x67b50eae, 0xe9e70119),
 	PCMCIA_DEVICE_NULL,
 };
diff --git a/drivers/mmc/host/sdricoh_cs.c b/drivers/mmc/host/sdricoh_cs.c
index bbc298f..496b7ef 100644
--- a/drivers/mmc/host/sdricoh_cs.c
+++ b/drivers/mmc/host/sdricoh_cs.c
@@ -76,7 +76,7 @@ static unsigned int switchlocked;
 #define BUSY_TIMEOUT      32767
 
 /* list of supported pcmcia devices */
-static struct pcmcia_device_id pcmcia_ids[] = {
+static const struct pcmcia_device_id pcmcia_ids[] = {
 	/* vendor and device strings followed by their crc32 hashes */
 	PCMCIA_DEVICE_PROD_ID12("RICOH", "Bay1Controller", 0xd9f522ed,
 				0xc3901202),
diff --git a/drivers/mtd/maps/pcmciamtd.c b/drivers/mtd/maps/pcmciamtd.c
index 6799e75..33dc2829 100644
--- a/drivers/mtd/maps/pcmciamtd.c
+++ b/drivers/mtd/maps/pcmciamtd.c
@@ -694,7 +694,7 @@ static int pcmciamtd_probe(struct pcmcia_device *link)
 	return pcmciamtd_config(link);
 }
 
-static struct pcmcia_device_id pcmciamtd_ids[] = {
+static const struct pcmcia_device_id pcmciamtd_ids[] = {
 	PCMCIA_DEVICE_FUNC_ID(1),
 	PCMCIA_DEVICE_PROD_ID123("IO DATA", "PCS-2M", "2MB SRAM", 0x547e66dc, 0x1fed36cd, 0x36eadd21),
 	PCMCIA_DEVICE_PROD_ID12("IBM", "2MB SRAM", 0xb569a6e5, 0x36eadd21),
diff --git a/drivers/net/can/softing/softing_cs.c b/drivers/net/can/softing/softing_cs.c
index c11bb4d..c0e1b1e 100644
--- a/drivers/net/can/softing/softing_cs.c
+++ b/drivers/net/can/softing/softing_cs.c
@@ -315,7 +315,7 @@ pcmcia_failed:
 	return ret ?: -ENODEV;
 }
 
-static /*const*/ struct pcmcia_device_id softingcs_ids[] = {
+static const struct pcmcia_device_id softingcs_ids[] = {
 	/* softing */
 	PCMCIA_DEVICE_MANF_CARD(0x0168, 0x0001),
 	PCMCIA_DEVICE_MANF_CARD(0x0168, 0x0002),
diff --git a/drivers/net/pcmcia/3c574_cs.c b/drivers/net/pcmcia/3c574_cs.c
index 81ac330..34c5e1c 100644
--- a/drivers/net/pcmcia/3c574_cs.c
+++ b/drivers/net/pcmcia/3c574_cs.c
@@ -1150,7 +1150,7 @@ static int el3_close(struct net_device *dev)
 	return 0;
 }
 
-static struct pcmcia_device_id tc574_ids[] = {
+static const struct pcmcia_device_id tc574_ids[] = {
 	PCMCIA_DEVICE_MANF_CARD(0x0101, 0x0574),
 	PCMCIA_MFC_DEVICE_CIS_MANF_CARD(0, 0x0101, 0x0556, "cis/3CCFEM556.cis"),
 	PCMCIA_DEVICE_NULL,
diff --git a/drivers/net/pcmcia/3c589_cs.c b/drivers/net/pcmcia/3c589_cs.c
index 79b9ca0..4a1a358 100644
--- a/drivers/net/pcmcia/3c589_cs.c
+++ b/drivers/net/pcmcia/3c589_cs.c
@@ -908,7 +908,7 @@ static int el3_close(struct net_device *dev)
     return 0;
 }
 
-static struct pcmcia_device_id tc589_ids[] = {
+static const struct pcmcia_device_id tc589_ids[] = {
 	PCMCIA_MFC_DEVICE_MANF_CARD(0, 0x0101, 0x0562),
 	PCMCIA_MFC_DEVICE_PROD_ID1(0, "Motorola MARQUIS", 0xf03e4e77),
 	PCMCIA_DEVICE_MANF_CARD(0x0101, 0x0589),
diff --git a/drivers/net/pcmcia/axnet_cs.c b/drivers/net/pcmcia/axnet_cs.c
index 3077d72..9953db7 100644
--- a/drivers/net/pcmcia/axnet_cs.c
+++ b/drivers/net/pcmcia/axnet_cs.c
@@ -687,7 +687,7 @@ static void block_output(struct net_device *dev, int count,
     outsw(nic_base + AXNET_DATAPORT, buf, count>>1);
 }
 
-static struct pcmcia_device_id axnet_ids[] = {
+static const struct pcmcia_device_id axnet_ids[] = {
 	PCMCIA_PFC_DEVICE_MANF_CARD(0, 0x016c, 0x0081),
 	PCMCIA_DEVICE_MANF_CARD(0x018a, 0x0301),
 	PCMCIA_DEVICE_MANF_CARD(0x01bf, 0x2328),
diff --git a/drivers/net/pcmcia/com20020_cs.c b/drivers/net/pcmcia/com20020_cs.c
index 27bfad7..980e65c 100644
--- a/drivers/net/pcmcia/com20020_cs.c
+++ b/drivers/net/pcmcia/com20020_cs.c
@@ -316,7 +316,7 @@ static int com20020_resume(struct pcmcia_device *link)
 	return 0;
 }
 
-static struct pcmcia_device_id com20020_ids[] = {
+static const struct pcmcia_device_id com20020_ids[] = {
 	PCMCIA_DEVICE_PROD_ID12("Contemporary Control Systems, Inc.",
 			"PCM20 Arcnet Adapter", 0x59991666, 0x95dfffaf),
 	PCMCIA_DEVICE_PROD_ID12("SoHard AG",
diff --git a/drivers/net/pcmcia/fmvj18x_cs.c b/drivers/net/pcmcia/fmvj18x_cs.c
index 530ab5a..723815e 100644
--- a/drivers/net/pcmcia/fmvj18x_cs.c
+++ b/drivers/net/pcmcia/fmvj18x_cs.c
@@ -667,7 +667,7 @@ static int fmvj18x_resume(struct pcmcia_device *link)
 
 /*====================================================================*/
 
-static struct pcmcia_device_id fmvj18x_ids[] = {
+static const struct pcmcia_device_id fmvj18x_ids[] = {
 	PCMCIA_DEVICE_MANF_CARD(0x0004, 0x0004),
 	PCMCIA_DEVICE_PROD_ID12("EAGLE Technology", "NE200 ETHERNET LAN MBH10302 04", 0x528c88c4, 0x74f91e59),
 	PCMCIA_DEVICE_PROD_ID12("Eiger Labs,Inc", "EPX-10BT PC Card Ethernet 10BT", 0x53af556e, 0x877f9922),
diff --git a/drivers/net/pcmcia/ibmtr_cs.c b/drivers/net/pcmcia/ibmtr_cs.c
index 15d57f5..6006d54 100644
--- a/drivers/net/pcmcia/ibmtr_cs.c
+++ b/drivers/net/pcmcia/ibmtr_cs.c
@@ -340,7 +340,7 @@ static void ibmtr_hw_setup(struct net_device *dev, u_int mmiobase)
     outb(0x40, dev->base_addr);
 }
 
-static struct pcmcia_device_id ibmtr_ids[] = {
+static const struct pcmcia_device_id ibmtr_ids[] = {
 	PCMCIA_DEVICE_PROD_ID12("3Com", "TokenLink Velocity PC Card", 0x41240e5b, 0x82c3734e),
 	PCMCIA_DEVICE_PROD_ID12("IBM", "TOKEN RING", 0xb569a6e5, 0xbf8eed47),
 	PCMCIA_DEVICE_NULL,
diff --git a/drivers/net/pcmcia/nmclan_cs.c b/drivers/net/pcmcia/nmclan_cs.c
index 76683d9..9d70b65 100644
--- a/drivers/net/pcmcia/nmclan_cs.c
+++ b/drivers/net/pcmcia/nmclan_cs.c
@@ -1494,7 +1494,7 @@ static void set_multicast_list(struct net_device *dev)
 
 } /* set_multicast_list */
 
-static struct pcmcia_device_id nmclan_ids[] = {
+static const struct pcmcia_device_id nmclan_ids[] = {
 	PCMCIA_DEVICE_PROD_ID12("New Media Corporation", "Ethernet", 0x085a850b, 0x00b2e941),
 	PCMCIA_DEVICE_PROD_ID12("Portable Add-ons", "Ethernet+", 0xebf1d60, 0xad673aaf),
 	PCMCIA_DEVICE_NULL,
diff --git a/drivers/net/pcmcia/pcnet_cs.c b/drivers/net/pcmcia/pcnet_cs.c
index e953793..b4fd7c3 100644
--- a/drivers/net/pcmcia/pcnet_cs.c
+++ b/drivers/net/pcmcia/pcnet_cs.c
@@ -1463,7 +1463,7 @@ failed:
 
 /*====================================================================*/
 
-static struct pcmcia_device_id pcnet_ids[] = {
+static const struct pcmcia_device_id pcnet_ids[] = {
 	PCMCIA_PFC_DEVICE_MANF_CARD(0, 0x0057, 0x0021),
 	PCMCIA_PFC_DEVICE_MANF_CARD(0, 0x0104, 0x000a),
 	PCMCIA_PFC_DEVICE_MANF_CARD(0, 0x0105, 0xea15),
diff --git a/drivers/net/pcmcia/smc91c92_cs.c b/drivers/net/pcmcia/smc91c92_cs.c
index 288e4f1..1cd9394 100644
--- a/drivers/net/pcmcia/smc91c92_cs.c
+++ b/drivers/net/pcmcia/smc91c92_cs.c
@@ -2014,7 +2014,7 @@ static int smc_ioctl (struct net_device *dev, struct ifreq *rq, int cmd)
 	return rc;
 }
 
-static struct pcmcia_device_id smc91c92_ids[] = {
+static const struct pcmcia_device_id smc91c92_ids[] = {
 	PCMCIA_PFC_DEVICE_MANF_CARD(0, 0x0109, 0x0501),
 	PCMCIA_PFC_DEVICE_MANF_CARD(0, 0x0140, 0x000a),
 	PCMCIA_PFC_DEVICE_PROD_ID123(0, "MEGAHERTZ", "CC/XJEM3288", "DATA/FAX/CELL ETHERNET MODEM", 0xf510db04, 0x04cd2988, 0x46a52d63),
diff --git a/drivers/net/pcmcia/xirc2ps_cs.c b/drivers/net/pcmcia/xirc2ps_cs.c
index a46b7fd..e33b190 100644
--- a/drivers/net/pcmcia/xirc2ps_cs.c
+++ b/drivers/net/pcmcia/xirc2ps_cs.c
@@ -1738,7 +1738,7 @@ do_stop(struct net_device *dev)
     return 0;
 }
 
-static struct pcmcia_device_id xirc2ps_ids[] = {
+static const struct pcmcia_device_id xirc2ps_ids[] = {
 	PCMCIA_PFC_DEVICE_MANF_CARD(0, 0x0089, 0x110a),
 	PCMCIA_PFC_DEVICE_MANF_CARD(0, 0x0138, 0x110a),
 	PCMCIA_PFC_DEVICE_PROD_ID13(0, "Xircom", "CEM28", 0x2e3ee845, 0x0ea978ea),
diff --git a/drivers/net/wireless/airo_cs.c b/drivers/net/wireless/airo_cs.c
index df2484d..c983c10 100644
--- a/drivers/net/wireless/airo_cs.c
+++ b/drivers/net/wireless/airo_cs.c
@@ -164,7 +164,7 @@ static int airo_resume(struct pcmcia_device *link)
 	return 0;
 }
 
-static struct pcmcia_device_id airo_ids[] = {
+static const struct pcmcia_device_id airo_ids[] = {
 	PCMCIA_DEVICE_MANF_CARD(0x015f, 0x000a),
 	PCMCIA_DEVICE_MANF_CARD(0x015f, 0x0005),
 	PCMCIA_DEVICE_MANF_CARD(0x015f, 0x0007),
diff --git a/drivers/net/wireless/atmel_cs.c b/drivers/net/wireless/atmel_cs.c
index 0526351..ec295c4 100644
--- a/drivers/net/wireless/atmel_cs.c
+++ b/drivers/net/wireless/atmel_cs.c
@@ -122,7 +122,7 @@ static int atmel_config(struct pcmcia_device *link)
 {
 	local_info_t *dev;
 	int ret;
-	struct pcmcia_device_id *did;
+	const struct pcmcia_device_id *did;
 
 	dev = link->priv;
 	did = dev_get_drvdata(&link->dev);
@@ -211,7 +211,7 @@ static int atmel_resume(struct pcmcia_device *link)
 	.prod_id_hash = { (vh1), (vh2), 0, 0 }, \
         .driver_info = (kernel_ulong_t)(info), }
 
-static struct pcmcia_device_id atmel_ids[] = {
+static const struct pcmcia_device_id atmel_ids[] = {
 	PCMCIA_DEVICE_MANF_CARD_INFO(0x0101, 0x0620, ATMEL_FW_TYPE_502_3COM),
 	PCMCIA_DEVICE_MANF_CARD_INFO(0x0101, 0x0696, ATMEL_FW_TYPE_502_3COM),
 	PCMCIA_DEVICE_MANF_CARD_INFO(0x01bf, 0x3302, ATMEL_FW_TYPE_502E),
diff --git a/drivers/net/wireless/b43/pcmcia.c b/drivers/net/wireless/b43/pcmcia.c
index 7dcba5f..2c8461d 100644
--- a/drivers/net/wireless/b43/pcmcia.c
+++ b/drivers/net/wireless/b43/pcmcia.c
@@ -32,7 +32,7 @@
 #include <pcmcia/cisreg.h>
 
 
-static /*const */ struct pcmcia_device_id b43_pcmcia_tbl[] = {
+static const struct pcmcia_device_id b43_pcmcia_tbl[] = {
 	PCMCIA_DEVICE_MANF_CARD(0x2D0, 0x448),
 	PCMCIA_DEVICE_MANF_CARD(0x2D0, 0x476),
 	PCMCIA_DEVICE_NULL,
diff --git a/drivers/net/wireless/hostap/hostap_cs.c b/drivers/net/wireless/hostap/hostap_cs.c
index 2176ede..c052a0d 100644
--- a/drivers/net/wireless/hostap/hostap_cs.c
+++ b/drivers/net/wireless/hostap/hostap_cs.c
@@ -620,7 +620,7 @@ static int hostap_cs_resume(struct pcmcia_device *link)
 	return 0;
 }
 
-static struct pcmcia_device_id hostap_cs_ids[] = {
+static const struct pcmcia_device_id hostap_cs_ids[] = {
 	PCMCIA_DEVICE_MANF_CARD(0x000b, 0x7100),
 	PCMCIA_DEVICE_MANF_CARD(0x000b, 0x7300),
 	PCMCIA_DEVICE_MANF_CARD(0x0101, 0x0777),
diff --git a/drivers/net/wireless/libertas/if_cs.c b/drivers/net/wireless/libertas/if_cs.c
index 4dfd48f..137ef67 100644
--- a/drivers/net/wireless/libertas/if_cs.c
+++ b/drivers/net/wireless/libertas/if_cs.c
@@ -976,7 +976,7 @@ static void if_cs_detach(struct pcmcia_device *p_dev)
 /* Module initialization                                            */
 /********************************************************************/
 
-static struct pcmcia_device_id if_cs_ids[] = {
+static const struct pcmcia_device_id if_cs_ids[] = {
 	PCMCIA_DEVICE_MANF_CARD(CF8305_MANFID, CF8305_CARDID),
 	PCMCIA_DEVICE_MANF_CARD(CF8381_MANFID, CF8381_CARDID),
 	PCMCIA_DEVICE_MANF_CARD(CF8385_MANFID, CF8385_CARDID),
diff --git a/drivers/net/wireless/orinoco/orinoco_cs.c b/drivers/net/wireless/orinoco/orinoco_cs.c
index 32954c4..88e3c0e 100644
--- a/drivers/net/wireless/orinoco/orinoco_cs.c
+++ b/drivers/net/wireless/orinoco/orinoco_cs.c
@@ -237,7 +237,7 @@ static int orinoco_cs_resume(struct pcmcia_device *link)
 /* Module initialization					    */
 /********************************************************************/
 
-static struct pcmcia_device_id orinoco_cs_ids[] = {
+static const struct pcmcia_device_id orinoco_cs_ids[] = {
 	PCMCIA_DEVICE_MANF_CARD(0x0101, 0x0777), /* 3Com AirConnect PCI 777A */
 	PCMCIA_DEVICE_MANF_CARD(0x0156, 0x0002), /* Lucent Orinoco and old Intersil */
 	PCMCIA_DEVICE_MANF_CARD(0x016b, 0x0001), /* Ericsson WLAN Card C11 */
diff --git a/drivers/net/wireless/orinoco/spectrum_cs.c b/drivers/net/wireless/orinoco/spectrum_cs.c
index db34c28..81f3673 100644
--- a/drivers/net/wireless/orinoco/spectrum_cs.c
+++ b/drivers/net/wireless/orinoco/spectrum_cs.c
@@ -301,7 +301,7 @@ spectrum_cs_resume(struct pcmcia_device *link)
 /* Module initialization					    */
 /********************************************************************/
 
-static struct pcmcia_device_id spectrum_cs_ids[] = {
+static const struct pcmcia_device_id spectrum_cs_ids[] = {
 	PCMCIA_DEVICE_MANF_CARD(0x026c, 0x0001), /* Symbol Spectrum24 LA4137 */
 	PCMCIA_DEVICE_MANF_CARD(0x0104, 0x0001), /* Socket Communications CF */
 	PCMCIA_DEVICE_PROD_ID12("Intel", "PRO/Wireless LAN PC Card", 0x816cc815, 0x6fbf459a), /* 2011B, not 2011 */
diff --git a/drivers/net/wireless/ray_cs.c b/drivers/net/wireless/ray_cs.c
index 0764d1a..2a06ebc 100644
--- a/drivers/net/wireless/ray_cs.c
+++ b/drivers/net/wireless/ray_cs.c
@@ -2781,7 +2781,7 @@ static const struct file_operations int_proc_fops = {
 };
 #endif
 
-static struct pcmcia_device_id ray_ids[] = {
+static const struct pcmcia_device_id ray_ids[] = {
 	PCMCIA_DEVICE_MANF_CARD(0x01a6, 0x0000),
 	PCMCIA_DEVICE_NULL,
 };
diff --git a/drivers/net/wireless/wl3501_cs.c b/drivers/net/wireless/wl3501_cs.c
index fc08f36..6bc7c92 100644
--- a/drivers/net/wireless/wl3501_cs.c
+++ b/drivers/net/wireless/wl3501_cs.c
@@ -2000,7 +2000,7 @@ static int wl3501_resume(struct pcmcia_device *link)
 }
 
 
-static struct pcmcia_device_id wl3501_ids[] = {
+static const struct pcmcia_device_id wl3501_ids[] = {
 	PCMCIA_DEVICE_MANF_CARD(0xd601, 0x0001),
 	PCMCIA_DEVICE_NULL
 };
diff --git a/drivers/parport/parport_cs.c b/drivers/parport/parport_cs.c
index 787ebde..067ad51 100644
--- a/drivers/parport/parport_cs.c
+++ b/drivers/parport/parport_cs.c
@@ -178,7 +178,7 @@ static void parport_cs_release(struct pcmcia_device *link)
 } /* parport_cs_release */
 
 
-static struct pcmcia_device_id parport_ids[] = {
+static const struct pcmcia_device_id parport_ids[] = {
 	PCMCIA_DEVICE_FUNC_ID(3),
 	PCMCIA_MFC_DEVICE_PROD_ID12(1,"Elan","Serial+Parallel Port: SP230",0x3beb8cf2,0xdb9e58bc),
 	PCMCIA_DEVICE_MANF_CARD(0x0137, 0x0003),
diff --git a/drivers/scsi/pcmcia/aha152x_stub.c b/drivers/scsi/pcmcia/aha152x_stub.c
index e77dd02..7d1609f 100644
--- a/drivers/scsi/pcmcia/aha152x_stub.c
+++ b/drivers/scsi/pcmcia/aha152x_stub.c
@@ -202,7 +202,7 @@ static int aha152x_resume(struct pcmcia_device *link)
 	return 0;
 }
 
-static struct pcmcia_device_id aha152x_ids[] = {
+static const struct pcmcia_device_id aha152x_ids[] = {
 	PCMCIA_DEVICE_PROD_ID123("New Media", "SCSI", "Bus Toaster", 0xcdf7e4cc, 0x35f26476, 0xa8851d6e),
 	PCMCIA_DEVICE_PROD_ID123("NOTEWORTHY", "SCSI", "Bus Toaster", 0xad89c6e8, 0x35f26476, 0xa8851d6e),
 	PCMCIA_DEVICE_PROD_ID12("Adaptec, Inc.", "APA-1460 SCSI Host Adapter", 0x24ba9738, 0x3a3c3d20),
diff --git a/drivers/scsi/pcmcia/fdomain_stub.c b/drivers/scsi/pcmcia/fdomain_stub.c
index cd69c26..714b248 100644
--- a/drivers/scsi/pcmcia/fdomain_stub.c
+++ b/drivers/scsi/pcmcia/fdomain_stub.c
@@ -178,7 +178,7 @@ static int fdomain_resume(struct pcmcia_device *link)
 	return 0;
 }
 
-static struct pcmcia_device_id fdomain_ids[] = {
+static const struct pcmcia_device_id fdomain_ids[] = {
 	PCMCIA_DEVICE_PROD_ID12("IBM Corp.", "SCSI PCMCIA Card", 0xe3736c88, 0x859cad20),
 	PCMCIA_DEVICE_PROD_ID1("SCSI PCMCIA Adapter Card", 0x8dacb57e),
 	PCMCIA_DEVICE_PROD_ID12(" SIMPLE TECHNOLOGY Corporation", "SCSI PCMCIA Credit Card Controller", 0x182bdafe, 0xc80d106f),
diff --git a/drivers/scsi/pcmcia/nsp_cs.c b/drivers/scsi/pcmcia/nsp_cs.c
index 54bdf6d..ca86721 100644
--- a/drivers/scsi/pcmcia/nsp_cs.c
+++ b/drivers/scsi/pcmcia/nsp_cs.c
@@ -1752,7 +1752,7 @@ static int nsp_cs_resume(struct pcmcia_device *link)
 /*======================================================================*
  *	module entry point
  *====================================================================*/
-static struct pcmcia_device_id nsp_cs_ids[] = {
+static const struct pcmcia_device_id nsp_cs_ids[] = {
 	PCMCIA_DEVICE_PROD_ID123("IO DATA", "CBSC16       ", "1", 0x547e66dc, 0x0d63a3fd, 0x51de003a),
 	PCMCIA_DEVICE_PROD_ID123("KME    ", "SCSI-CARD-001", "1", 0x534c02bc, 0x52008408, 0x51de003a),
 	PCMCIA_DEVICE_PROD_ID123("KME    ", "SCSI-CARD-002", "1", 0x534c02bc, 0xcb09d5b2, 0x51de003a),
diff --git a/drivers/scsi/pcmcia/qlogic_stub.c b/drivers/scsi/pcmcia/qlogic_stub.c
index 9c96ca8..bcaf89f 100644
--- a/drivers/scsi/pcmcia/qlogic_stub.c
+++ b/drivers/scsi/pcmcia/qlogic_stub.c
@@ -270,7 +270,7 @@ static int qlogic_resume(struct pcmcia_device *link)
 	return 0;
 }
 
-static struct pcmcia_device_id qlogic_ids[] = {
+static const struct pcmcia_device_id qlogic_ids[] = {
 	PCMCIA_DEVICE_PROD_ID12("EIger Labs", "PCMCIA-to-SCSI Adapter", 0x88395fa7, 0x33b7a5e6),
 	PCMCIA_DEVICE_PROD_ID12("EPSON", "SCSI-2 PC Card SC200", 0xd361772f, 0x299d1751),
 	PCMCIA_DEVICE_PROD_ID12("MACNICA", "MIRACLE SCSI-II mPS110", 0x20841b68, 0xab3c3b6d),
diff --git a/drivers/scsi/pcmcia/sym53c500_cs.c b/drivers/scsi/pcmcia/sym53c500_cs.c
index 8552296..f5b5273 100644
--- a/drivers/scsi/pcmcia/sym53c500_cs.c
+++ b/drivers/scsi/pcmcia/sym53c500_cs.c
@@ -865,7 +865,7 @@ MODULE_AUTHOR("Bob Tracy <rct@frus.com>");
 MODULE_DESCRIPTION("SYM53C500 PCMCIA SCSI driver");
 MODULE_LICENSE("GPL");
 
-static struct pcmcia_device_id sym53c500_ids[] = {
+static const struct pcmcia_device_id sym53c500_ids[] = {
 	PCMCIA_DEVICE_PROD_ID12("BASICS by New Media Corporation", "SCSI Sym53C500", 0x23c78a9d, 0x0099e7f7),
 	PCMCIA_DEVICE_PROD_ID12("New Media Corporation", "SCSI Bus Toaster Sym53C500", 0x085a850b, 0x45432eb8),
 	PCMCIA_DEVICE_PROD_ID2("SCSI9000", 0x21648f44),
diff --git a/drivers/telephony/ixj_pcmcia.c b/drivers/telephony/ixj_pcmcia.c
index d005b9e..05032e2 100644
--- a/drivers/telephony/ixj_pcmcia.c
+++ b/drivers/telephony/ixj_pcmcia.c
@@ -157,7 +157,7 @@ static void ixj_cs_release(struct pcmcia_device *link)
 	pcmcia_disable_device(link);
 }
 
-static struct pcmcia_device_id ixj_ids[] = {
+static const struct pcmcia_device_id ixj_ids[] = {
 	PCMCIA_DEVICE_MANF_CARD(0x0257, 0x0600),
 	PCMCIA_DEVICE_NULL
 };
diff --git a/drivers/tty/ipwireless/main.c b/drivers/tty/ipwireless/main.c
index 444155a..655c794 100644
--- a/drivers/tty/ipwireless/main.c
+++ b/drivers/tty/ipwireless/main.c
@@ -33,7 +33,7 @@
 #include <pcmcia/ss.h>
 #include <pcmcia/ds.h>
 
-static struct pcmcia_device_id ipw_ids[] = {
+static const struct pcmcia_device_id ipw_ids[] = {
 	PCMCIA_DEVICE_MANF_CARD(0x02f2, 0x0100),
 	PCMCIA_DEVICE_MANF_CARD(0x02f2, 0x0200),
 	PCMCIA_DEVICE_NULL
diff --git a/drivers/tty/serial/serial_cs.c b/drivers/tty/serial/serial_cs.c
index 1ef4df9..eef736f 100644
--- a/drivers/tty/serial/serial_cs.c
+++ b/drivers/tty/serial/serial_cs.c
@@ -670,7 +670,7 @@ failed:
 	return -ENODEV;
 }
 
-static struct pcmcia_device_id serial_ids[] = {
+static const struct pcmcia_device_id serial_ids[] = {
 	PCMCIA_PFC_DEVICE_MANF_CARD(1, 0x0057, 0x0021),
 	PCMCIA_PFC_DEVICE_MANF_CARD(1, 0x0089, 0x110a),
 	PCMCIA_PFC_DEVICE_MANF_CARD(1, 0x0104, 0x000a),
diff --git a/drivers/usb/host/sl811_cs.c b/drivers/usb/host/sl811_cs.c
index 3775c03..3b6f50e 100644
--- a/drivers/usb/host/sl811_cs.c
+++ b/drivers/usb/host/sl811_cs.c
@@ -187,7 +187,7 @@ static int sl811_cs_probe(struct pcmcia_device *link)
 	return sl811_cs_config(link);
 }
 
-static struct pcmcia_device_id sl811_ids[] = {
+static const struct pcmcia_device_id sl811_ids[] = {
 	PCMCIA_DEVICE_MANF_CARD(0xc015, 0x0001), /* RATOC USB HOST CF+ Card */
 	PCMCIA_DEVICE_NULL,
 };
-- 
1.7.5.rc3.dirty


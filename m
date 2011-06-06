Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757178Ab1FFSJg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 14:09:36 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56462 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426Ab1FFSJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 14:09:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=sy7wDFonKU8+an7D17XZjVKgxBdJB5qspdsN/TJjveBw0ZvTEhVwtYOQq9AnwHXLi8
         bJ34e2WAVZTfa0Un9t3S74qoD4gGKzQBZ0zQZmA7syQsxpHj6+phEBDcKNj/knwln0uJ
         eyptAbEGBAuGKpzFVQv7ZieMxSSKW1/mKUzfo=
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com, alan@lxorguk.ukuu.org.uk,
        Mark Einon <Mark.Einon@gmail.com>, Mark Einon <mark.einon@gmail.com>
Subject: [PATCH v2 1/7] staging: et131x: checkpatch fixes for et1310_address_map.h (All 'do not add new typedefs')
Date: Mon,  6 Jun 2011 19:06:58 +0100
Message-Id: <1307383624-8740-2-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1307383624-8740-1-git-send-email-mark.einon@gmail.com>
References: <1307295320-31716-1-git-send-email-mark.einon@gmail.com>
 <1307383624-8740-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Einon <Mark.Einon@gmail.com>

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et1310_address_map.h |   62 +++++++++++++-------------
 drivers/staging/et131x/et1310_mac.c         |   24 +++++-----
 drivers/staging/et131x/et1310_phy.c         |    6 +-
 drivers/staging/et131x/et131x_adapter.h     |    2 +-
 drivers/staging/et131x/et131x_isr.c         |    2 +-
 5 files changed, 48 insertions(+), 48 deletions(-)

diff --git a/drivers/staging/et131x/et1310_address_map.h b/drivers/staging/et131x/et1310_address_map.h
index 425e927..6f52627 100644
--- a/drivers/staging/et131x/et1310_address_map.h
+++ b/drivers/staging/et131x/et1310_address_map.h
@@ -701,7 +701,7 @@ struct txmac_regs {			/* Location: */
  * structure for Wake On Lan Source Address Lo reg in rxmac address map
  * located at address 0x4010
  */
-typedef union _RXMAC_WOL_SA_LO_t {
+union RXMAC_WOL_SA_LO_t {
 	u32 value;
 	struct {
 #ifdef _BIT_FIELDS_HTOL
@@ -716,13 +716,13 @@ typedef union _RXMAC_WOL_SA_LO_t {
 		u32 sa3:8;	/* bits 24-31 */
 #endif
 	} bits;
-} RXMAC_WOL_SA_LO_t, *PRXMAC_WOL_SA_LO_t;
+};
 
 /*
  * structure for Wake On Lan Source Address Hi reg in rxmac address map
  * located at address 0x4014
  */
-typedef union _RXMAC_WOL_SA_HI_t {
+union RXMAC_WOL_SA_HI_t {
 	u32 value;
 	struct {
 #ifdef _BIT_FIELDS_HTOL
@@ -735,7 +735,7 @@ typedef union _RXMAC_WOL_SA_HI_t {
 		u32 reserved:16;	/* bits 16-31 */
 #endif
 	} bits;
-} RXMAC_WOL_SA_HI_t, *PRXMAC_WOL_SA_HI_t;
+};
 
 /*
  * structure for Wake On Lan mask reg in rxmac address map
@@ -747,7 +747,7 @@ typedef union _RXMAC_WOL_SA_HI_t {
  * structure for Unicast Paket Filter Address 1 reg in rxmac address map
  * located at address 0x4068
  */
-typedef union _RXMAC_UNI_PF_ADDR1_t {
+union RXMAC_UNI_PF_ADDR1_t {
 	u32 value;
 	struct {
 #ifdef _BIT_FIELDS_HTOL
@@ -762,13 +762,13 @@ typedef union _RXMAC_UNI_PF_ADDR1_t {
 		u32 addr1_3:8;	/* bits 24-31 */
 #endif
 	} bits;
-} RXMAC_UNI_PF_ADDR1_t, *PRXMAC_UNI_PF_ADDR1_t;
+};
 
 /*
  * structure for Unicast Paket Filter Address 2 reg in rxmac address map
  * located at address 0x406C
  */
-typedef union _RXMAC_UNI_PF_ADDR2_t {
+union RXMAC_UNI_PF_ADDR2_t {
 	u32 value;
 	struct {
 #ifdef _BIT_FIELDS_HTOL
@@ -783,13 +783,13 @@ typedef union _RXMAC_UNI_PF_ADDR2_t {
 		u32 addr2_3:8;	/* bits 24-31 */
 #endif
 	} bits;
-} RXMAC_UNI_PF_ADDR2_t, *PRXMAC_UNI_PF_ADDR2_t;
+};
 
 /*
  * structure for Unicast Paket Filter Address 1 & 2 reg in rxmac address map
  * located at address 0x4070
  */
-typedef union _RXMAC_UNI_PF_ADDR3_t {
+union RXMAC_UNI_PF_ADDR3_t {
 	u32 value;
 	struct {
 #ifdef _BIT_FIELDS_HTOL
@@ -804,7 +804,7 @@ typedef union _RXMAC_UNI_PF_ADDR3_t {
 		u32 addr2_1:8;	/* bits 24-31 */
 #endif
 	} bits;
-} RXMAC_UNI_PF_ADDR3_t, *PRXMAC_UNI_PF_ADDR3_t;
+};
 
 /*
  * structure for Multicast Hash reg in rxmac address map
@@ -888,13 +888,13 @@ typedef union _RXMAC_UNI_PF_ADDR3_t {
 /*
  * Rx MAC Module of JAGCore Address Mapping
  */
-typedef struct _RXMAC_t {				/* Location: */
+struct RXMAC_t {					/* Location: */
 	u32 ctrl;					/*  0x4000 */
 	u32 crc0;					/*  0x4004 */
 	u32 crc12;					/*  0x4008 */
 	u32 crc34;					/*  0x400C */
-	RXMAC_WOL_SA_LO_t sa_lo;			/*  0x4010 */
-	RXMAC_WOL_SA_HI_t sa_hi;			/*  0x4014 */
+	union RXMAC_WOL_SA_LO_t sa_lo;			/*  0x4010 */
+	union RXMAC_WOL_SA_HI_t sa_hi;			/*  0x4014 */
 	u32 mask0_word0;				/*  0x4018 */
 	u32 mask0_word1;				/*  0x401C */
 	u32 mask0_word2;				/*  0x4020 */
@@ -915,9 +915,9 @@ typedef struct _RXMAC_t {				/* Location: */
 	u32 mask4_word1;				/*  0x405C */
 	u32 mask4_word2;				/*  0x4060 */
 	u32 mask4_word3;				/*  0x4064 */
-	RXMAC_UNI_PF_ADDR1_t uni_pf_addr1;		/*  0x4068 */
-	RXMAC_UNI_PF_ADDR2_t uni_pf_addr2;		/*  0x406C */
-	RXMAC_UNI_PF_ADDR3_t uni_pf_addr3;		/*  0x4070 */
+	union RXMAC_UNI_PF_ADDR1_t uni_pf_addr1;	/*  0x4068 */
+	union RXMAC_UNI_PF_ADDR2_t uni_pf_addr2;	/*  0x406C */
+	union RXMAC_UNI_PF_ADDR3_t uni_pf_addr3;	/*  0x4070 */
 	u32 multi_hash1;				/*  0x4074 */
 	u32 multi_hash2;				/*  0x4078 */
 	u32 multi_hash3;				/*  0x407C */
@@ -930,7 +930,7 @@ typedef struct _RXMAC_t {				/* Location: */
 
 	u32 mif_ctrl;					/*  0x4098 */
 	u32 err_reg;					/*  0x409C */
-} RXMAC_t, *PRXMAC_t;
+};
 
 /* END OF RXMAC REGISTER ADDRESS MAP */
 
@@ -1124,7 +1124,7 @@ typedef struct _RXMAC_t {				/* Location: */
  * structure for Mac Station Address, Part 1 reg in mac address map.
  * located at address 0x5040
  */
-typedef union _MAC_STATION_ADDR1_t {
+union MAC_STATION_ADDR1_t {
 	u32 value;
 	struct {
 #ifdef _BIT_FIELDS_HTOL
@@ -1139,13 +1139,13 @@ typedef union _MAC_STATION_ADDR1_t {
 		u32 Octet6:8;	/* bits 24-31 */
 #endif
 	} bits;
-} MAC_STATION_ADDR1_t, *PMAC_STATION_ADDR1_t;
+};
 
 /*
  * structure for Mac Station Address, Part 2 reg in mac address map.
  * located at address 0x5044
  */
-typedef union _MAC_STATION_ADDR2_t {
+union MAC_STATION_ADDR2_t {
 	u32 value;
 	struct {
 #ifdef _BIT_FIELDS_HTOL
@@ -1158,12 +1158,12 @@ typedef union _MAC_STATION_ADDR2_t {
 		u32 Octet2:8;	/* bits 24-31 */
 #endif
 	} bits;
-} MAC_STATION_ADDR2_t, *PMAC_STATION_ADDR2_t;
+};
 
 /*
  * MAC Module of JAGCore Address Mapping
  */
-typedef struct _MAC_t {					/* Location: */
+struct MAC_t {						/* Location: */
 	u32 cfg1;					/*  0x5000 */
 	u32 cfg2;					/*  0x5004 */
 	u32 ipg;					/*  0x5008 */
@@ -1180,9 +1180,9 @@ typedef struct _MAC_t {					/* Location: */
 	u32 mii_mgmt_indicator;				/*  0x5034 */
 	u32 if_ctrl;					/*  0x5038 */
 	u32 if_stat;					/*  0x503C */
-	MAC_STATION_ADDR1_t station_addr_1;		/*  0x5040 */
-	MAC_STATION_ADDR2_t station_addr_2;		/*  0x5044 */
-} MAC_t, *PMAC_t;
+	union MAC_STATION_ADDR1_t station_addr_1;	/*  0x5040 */
+	union MAC_STATION_ADDR2_t station_addr_2;	/*  0x5044 */
+};
 
 /* END OF MAC REGISTER ADDRESS MAP */
 
@@ -1448,7 +1448,7 @@ struct mmc_regs {		/* Location: */
 /*
  * JAGCore Address Mapping
  */
-typedef struct _ADDRESS_MAP_t {
+struct ADDRESS_MAP_t {
 	struct global_regs global;
 	/* unused section of global address map */
 	u8 unused_global[4096 - sizeof(struct global_regs)];
@@ -1461,12 +1461,12 @@ typedef struct _ADDRESS_MAP_t {
 	struct txmac_regs txmac;
 	/* unused section of txmac address map */
 	u8 unused_txmac[4096 - sizeof(struct txmac_regs)];
-	RXMAC_t rxmac;
+	struct RXMAC_t rxmac;
 	/* unused section of rxmac address map */
-	u8 unused_rxmac[4096 - sizeof(RXMAC_t)];
-	MAC_t mac;
+	u8 unused_rxmac[4096 - sizeof(struct RXMAC_t)];
+	struct MAC_t mac;
 	/* unused section of mac address map */
-	u8 unused_mac[4096 - sizeof(MAC_t)];
+	u8 unused_mac[4096 - sizeof(struct MAC_t)];
 	struct macstat_regs macstat;
 	/* unused section of mac stat address map */
 	u8 unused_mac_stat[4096 - sizeof(struct macstat_regs)];
@@ -1478,6 +1478,6 @@ typedef struct _ADDRESS_MAP_t {
 
 	u8 unused_exp_rom[4096];	/* MGS-size TBD */
 	u8 unused__[524288];	/* unused section of address map */
-} ADDRESS_MAP_t, *PADDRESS_MAP_t;
+};
 
 #endif /* _ET1310_ADDRESS_MAP_H_ */
diff --git a/drivers/staging/et131x/et1310_mac.c b/drivers/staging/et131x/et1310_mac.c
index 78f72fa..c634e35 100644
--- a/drivers/staging/et131x/et1310_mac.c
+++ b/drivers/staging/et131x/et1310_mac.c
@@ -104,9 +104,9 @@
  */
 void ConfigMACRegs1(struct et131x_adapter *etdev)
 {
-	struct _MAC_t __iomem *pMac = &etdev->regs->mac;
-	MAC_STATION_ADDR1_t station1;
-	MAC_STATION_ADDR2_t station2;
+	struct MAC_t __iomem *pMac = &etdev->regs->mac;
+	union MAC_STATION_ADDR1_t station1;
+	union MAC_STATION_ADDR2_t station2;
 	u32 ipg;
 
 	/* First we need to reset everything.  Write to MAC configuration
@@ -165,7 +165,7 @@ void ConfigMACRegs1(struct et131x_adapter *etdev)
 void ConfigMACRegs2(struct et131x_adapter *etdev)
 {
 	int32_t delay = 0;
-	struct _MAC_t __iomem *pMac = &etdev->regs->mac;
+	struct MAC_t __iomem *pMac = &etdev->regs->mac;
 	u32 cfg1;
 	u32 cfg2;
 	u32 ifctrl;
@@ -237,9 +237,9 @@ void ConfigMACRegs2(struct et131x_adapter *etdev)
 
 void ConfigRxMacRegs(struct et131x_adapter *etdev)
 {
-	struct _RXMAC_t __iomem *pRxMac = &etdev->regs->rxmac;
-	RXMAC_WOL_SA_LO_t sa_lo;
-	RXMAC_WOL_SA_HI_t sa_hi;
+	struct RXMAC_t __iomem *pRxMac = &etdev->regs->rxmac;
+	union RXMAC_WOL_SA_LO_t sa_lo;
+	union RXMAC_WOL_SA_HI_t sa_hi;
 	u32 pf_ctrl = 0;
 
 	/* Disable the MAC while it is being configured (also disable WOL) */
@@ -534,7 +534,7 @@ void HandleMacStatInterrupt(struct et131x_adapter *etdev)
 
 void SetupDeviceForMulticast(struct et131x_adapter *etdev)
 {
-	struct _RXMAC_t __iomem *rxmac = &etdev->regs->rxmac;
+	struct RXMAC_t __iomem *rxmac = &etdev->regs->rxmac;
 	uint32_t nIndex;
 	uint32_t result;
 	uint32_t hash1 = 0;
@@ -582,10 +582,10 @@ void SetupDeviceForMulticast(struct et131x_adapter *etdev)
 
 void SetupDeviceForUnicast(struct et131x_adapter *etdev)
 {
-	struct _RXMAC_t __iomem *rxmac = &etdev->regs->rxmac;
-	RXMAC_UNI_PF_ADDR1_t uni_pf1;
-	RXMAC_UNI_PF_ADDR2_t uni_pf2;
-	RXMAC_UNI_PF_ADDR3_t uni_pf3;
+	struct RXMAC_t __iomem *rxmac = &etdev->regs->rxmac;
+	union RXMAC_UNI_PF_ADDR1_t uni_pf1;
+	union RXMAC_UNI_PF_ADDR2_t uni_pf2;
+	union RXMAC_UNI_PF_ADDR3_t uni_pf3;
 	u32 pm_csr;
 
 	/* Set up unicast packet filter reg 3 to be the first two octets of
diff --git a/drivers/staging/et131x/et1310_phy.c b/drivers/staging/et131x/et1310_phy.c
index 2798a2f..bc8d385 100644
--- a/drivers/staging/et131x/et1310_phy.c
+++ b/drivers/staging/et131x/et1310_phy.c
@@ -108,7 +108,7 @@ static void et131x_xcvr_init(struct et131x_adapter *etdev);
 int PhyMiRead(struct et131x_adapter *etdev, u8 xcvrAddr,
 	      u8 xcvrReg, u16 *value)
 {
-	struct _MAC_t __iomem *mac = &etdev->regs->mac;
+	struct MAC_t __iomem *mac = &etdev->regs->mac;
 	int status = 0;
 	u32 delay;
 	u32 miiAddr;
@@ -176,7 +176,7 @@ int PhyMiRead(struct et131x_adapter *etdev, u8 xcvrAddr,
  */
 int MiWrite(struct et131x_adapter *etdev, u8 xcvrReg, u16 value)
 {
-	struct _MAC_t __iomem *mac = &etdev->regs->mac;
+	struct MAC_t __iomem *mac = &etdev->regs->mac;
 	int status = 0;
 	u8 xcvrAddr = etdev->Stats.xcvr_addr;
 	u32 delay;
@@ -590,7 +590,7 @@ static void et131x_xcvr_init(struct et131x_adapter *etdev)
 	/* Set the link status interrupt only.  Bad behavior when link status
 	 * and auto neg are set, we run into a nested interrupt problem
 	 */
-        imr |= 0x0105;
+	imr |= 0x0105;
 
 	MiWrite(etdev, (u8) offsetof(struct mi_regs, imr), imr);
 
diff --git a/drivers/staging/et131x/et131x_adapter.h b/drivers/staging/et131x/et131x_adapter.h
index c852f86..c9a119e 100644
--- a/drivers/staging/et131x/et131x_adapter.h
+++ b/drivers/staging/et131x/et131x_adapter.h
@@ -186,7 +186,7 @@ struct et131x_adapter {
 	u8 MCList[NIC_MAX_MCAST_LIST][ETH_ALEN];
 
 	/* Pointer to the device's PCI register space */
-	ADDRESS_MAP_t __iomem *regs;
+	struct ADDRESS_MAP_t __iomem *regs;
 
 	/* Registry parameters */
 	u8 SpeedDuplex;		/* speed/duplex */
diff --git a/drivers/staging/et131x/et131x_isr.c b/drivers/staging/et131x/et131x_isr.c
index f716e40..7c7b464 100644
--- a/drivers/staging/et131x/et131x_isr.c
+++ b/drivers/staging/et131x/et131x_isr.c
@@ -245,7 +245,7 @@ void et131x_isr_handler(struct work_struct *work)
 	struct et131x_adapter *etdev =
 		container_of(work, struct et131x_adapter, task);
 	u32 status = etdev->Stats.InterruptStatus;
-	ADDRESS_MAP_t __iomem *iomem = etdev->regs;
+	struct ADDRESS_MAP_t __iomem *iomem = etdev->regs;
 
 	/*
 	 * These first two are by far the most common.  Once handled, we clear
-- 
1.7.4.4


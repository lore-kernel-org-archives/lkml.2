Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864Ab2HVKLj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 06:11:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39195 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298Ab2HVKLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 06:11:34 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: trivial@kernel.org, linux-kernel@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial] Fix typo "suport" in various comments and Kconfig
Date: Wed, 22 Aug 2012 19:11:26 +0900
Message-Id: <1345630286-7517-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.12.rc3.4.g91e4bfe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix spelling typo "suport" in comments and a Kconfig.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 Documentation/hwmon/pmbus                      | 2 +-
 Documentation/video4linux/bttv/Sound-FAQ       | 2 +-
 arch/mips/txx9/generic/pci.c                   | 2 +-
 arch/powerpc/include/asm/oprofile_impl.h       | 2 +-
 arch/sh/boards/board-espt.c                    | 2 +-
 drivers/acpi/acpica/dsopcode.c                 | 2 +-
 drivers/media/video/uvc/uvc_video.c            | 2 +-
 drivers/net/bonding/bonding.h                  | 2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c | 2 +-
 drivers/net/ethernet/micrel/ksz884x.c          | 2 +-
 drivers/net/wireless/atmel.c                   | 2 +-
 drivers/net/wireless/ipw2x00/ipw2100.h         | 2 +-
 drivers/regulator/palmas-regulator.c           | 2 +-
 drivers/scsi/libsas/sas_expander.c             | 2 +-
 drivers/staging/comedi/drivers/usbdux.c        | 2 +-
 drivers/staging/csr/netdev.c                   | 2 +-
 drivers/staging/tidspbridge/rmgr/node.c        | 2 +-
 drivers/usb/core/driver.c                      | 2 +-
 fs/cifs/README                                 | 2 +-
 fs/notify/fanotify/Kconfig                     | 2 +-
 include/linux/atmbr2684.h                      | 2 +-
 include/linux/stmmac.h                         | 2 +-
 net/ipv4/tcp_cong.c                            | 2 +-
 net/mac80211/driver-ops.h                      | 2 +-
 net/sctp/endpointola.c                         | 2 +-
 net/sctp/sm_statefuns.c                        | 2 +-
 sound/pci/ice1712/delta.c                      | 2 +-
 27 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/Documentation/hwmon/pmbus b/Documentation/hwmon/pmbus
index f90f999..3d3a0f9 100644
--- a/Documentation/hwmon/pmbus
+++ b/Documentation/hwmon/pmbus
@@ -138,7 +138,7 @@ Sysfs entries
 
 When probing the chip, the driver identifies which PMBus registers are
 supported, and determines available sensors from this information.
-Attribute files only exist if respective sensors are suported by the chip.
+Attribute files only exist if respective sensors are supported by the chip.
 Labels are provided to inform the user about the sensor associated with
 a given sysfs entry.
 
diff --git a/Documentation/video4linux/bttv/Sound-FAQ b/Documentation/video4linux/bttv/Sound-FAQ
index 395f6c6..d3f1d77 100644
--- a/Documentation/video4linux/bttv/Sound-FAQ
+++ b/Documentation/video4linux/bttv/Sound-FAQ
@@ -82,7 +82,7 @@ card installed, you might to check out if you can read these registers
 values used by the windows driver.  A tool to do this is available
 from ftp://telepresence.dmem.strath.ac.uk/pub/bt848/winutil, but it
 does'nt work with bt878 boards according to some reports I received.
-Another one with bt878 suport is available from
+Another one with bt878 support is available from
 http://btwincap.sourceforge.net/Files/btspy2.00.zip
 
 You might also dig around in the *.ini files of the Windows applications.
diff --git a/arch/mips/txx9/generic/pci.c b/arch/mips/txx9/generic/pci.c
index 4efd918..b14ee53 100644
--- a/arch/mips/txx9/generic/pci.c
+++ b/arch/mips/txx9/generic/pci.c
@@ -341,7 +341,7 @@ static void __devinit quirk_slc90e66_ide(struct pci_dev *dev)
 
 static void __devinit tc35815_fixup(struct pci_dev *dev)
 {
-	/* This device may have PM registers but not they are not suported. */
+	/* This device may have PM registers but not they are not supported. */
 	if (dev->pm_cap) {
 		dev_info(&dev->dev, "PM disabled\n");
 		dev->pm_cap = 0;
diff --git a/arch/powerpc/include/asm/oprofile_impl.h b/arch/powerpc/include/asm/oprofile_impl.h
index 639dc96..d697b08 100644
--- a/arch/powerpc/include/asm/oprofile_impl.h
+++ b/arch/powerpc/include/asm/oprofile_impl.h
@@ -34,7 +34,7 @@ struct op_system_config {
 	unsigned long mmcra;
 #ifdef CONFIG_OPROFILE_CELL
 	/* Register for oprofile user tool to check cell kernel profiling
-	 * suport.
+	 * support.
 	 */
 	unsigned long cell_support;
 #endif
diff --git a/arch/sh/boards/board-espt.c b/arch/sh/boards/board-espt.c
index 6cba0a7..d71a0bc 100644
--- a/arch/sh/boards/board-espt.c
+++ b/arch/sh/boards/board-espt.c
@@ -1,5 +1,5 @@
 /*
- * Data Technology Inc. ESPT-GIGA board suport
+ * Data Technology Inc. ESPT-GIGA board support
  *
  * Copyright (C) 2008, 2009 Renesas Solutions Corp.
  * Copyright (C) 2008, 2009 Nobuhiro Iwamatsu <iwamatsu.nobuhiro@renesas.com>
diff --git a/drivers/acpi/acpica/dsopcode.c b/drivers/acpi/acpica/dsopcode.c
index aa34d89..4fbb45f 100644
--- a/drivers/acpi/acpica/dsopcode.c
+++ b/drivers/acpi/acpica/dsopcode.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Module Name: dsopcode - Dispatcher suport for regions and fields
+ * Module Name: dsopcode - Dispatcher support for regions and fields
  *
  *****************************************************************************/
 
diff --git a/drivers/media/video/uvc/uvc_video.c b/drivers/media/video/uvc/uvc_video.c
index 7ac4347..c3fccbf 100644
--- a/drivers/media/video/uvc/uvc_video.c
+++ b/drivers/media/video/uvc/uvc_video.c
@@ -1747,7 +1747,7 @@ int uvc_video_init(struct uvc_streaming *stream)
 	usb_set_interface(stream->dev->udev, stream->intfnum, 0);
 
 	/* Set the streaming probe control with default streaming parameters
-	 * retrieved from the device. Webcams that don't suport GET_DEF
+	 * retrieved from the device. Webcams that don't support GET_DEF
 	 * requests on the probe control will just keep their current streaming
 	 * parameters.
 	 */
diff --git a/drivers/net/bonding/bonding.h b/drivers/net/bonding/bonding.h
index f8af2fc..486b1cb 100644
--- a/drivers/net/bonding/bonding.h
+++ b/drivers/net/bonding/bonding.h
@@ -244,7 +244,7 @@ struct bonding {
 	struct   delayed_work ad_work;
 	struct   delayed_work mcast_work;
 #ifdef CONFIG_DEBUG_FS
-	/* debugging suport via debugfs */
+	/* debugging support via debugfs */
 	struct	 dentry *debug_dir;
 #endif /* CONFIG_DEBUG_FS */
 };
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c
index 62f754b..525cee5 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c
@@ -4319,7 +4319,7 @@ static int bnx2x_queue_comp_cmd(struct bnx2x *bp,
 
 	if (o->next_tx_only >= o->max_cos)
 		/* >= becuase tx only must always be smaller than cos since the
-		 * primary connection suports COS 0
+		 * primary connection supports COS 0
 		 */
 		BNX2X_ERR("illegal value for next tx_only: %d. max cos was %d",
 			   o->next_tx_only, o->max_cos);
diff --git a/drivers/net/ethernet/micrel/ksz884x.c b/drivers/net/ethernet/micrel/ksz884x.c
index 318fee9..693a88d 100644
--- a/drivers/net/ethernet/micrel/ksz884x.c
+++ b/drivers/net/ethernet/micrel/ksz884x.c
@@ -6767,7 +6767,7 @@ static int stp;
 /*
  * This enables fast aging in the KSZ8842 switch.  Not sure what situation
  * needs that.  However, fast aging is used to flush the dynamic MAC table when
- * STP suport is enabled.
+ * STP support is enabled.
  */
 static int fast_aging;
 
diff --git a/drivers/net/wireless/atmel.c b/drivers/net/wireless/atmel.c
index 4a4e98f..4374079 100644
--- a/drivers/net/wireless/atmel.c
+++ b/drivers/net/wireless/atmel.c
@@ -2963,7 +2963,7 @@ static void send_association_request(struct atmel_private *priv, int is_reassoc)
 	ssid_el_p[1] = priv->SSID_size;
 	memcpy(ssid_el_p + 2, priv->SSID, priv->SSID_size);
 	ssid_el_p[2 + priv->SSID_size] = WLAN_EID_SUPP_RATES;
-	ssid_el_p[3 + priv->SSID_size] = 4; /* len of suported rates */
+	ssid_el_p[3 + priv->SSID_size] = 4; /* len of supported rates */
 	memcpy(ssid_el_p + 4 + priv->SSID_size, atmel_basic_rates, 4);
 
 	atmel_transmit_management_frame(priv, &header, (void *)&body, bodysize);
diff --git a/drivers/net/wireless/ipw2x00/ipw2100.h b/drivers/net/wireless/ipw2x00/ipw2100.h
index 9731252..5fe17cb 100644
--- a/drivers/net/wireless/ipw2x00/ipw2100.h
+++ b/drivers/net/wireless/ipw2x00/ipw2100.h
@@ -1045,7 +1045,7 @@ typedef enum _ORDINAL_TABLE_1 {	// NS - means Not Supported by FW
 	IPW_ORD_POWER_MGMT_MODE,	// Power mode - 0=CAM, 1=PSP
 	IPW_ORD_POWER_MGMT_INDEX,	//NS //
 	IPW_ORD_COUNTRY_CODE,	// IEEE country code as recv'd from beacon
-	IPW_ORD_COUNTRY_CHANNELS,	// channels suported by country
+	IPW_ORD_COUNTRY_CHANNELS,	// channels supported by country
 // IPW_ORD_COUNTRY_CHANNELS:
 // For 11b the lower 2-byte are used for channels from 1-14
 //   and the higher 2-byte are not used.
diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
index 2ba7502..fe161359 100644
--- a/drivers/regulator/palmas-regulator.c
+++ b/drivers/regulator/palmas-regulator.c
@@ -673,7 +673,7 @@ static __devinit int palmas_probe(struct platform_device *pdev)
 		/*
 		 * read and store the RANGE bit for later use
 		 * This must be done before regulator is probed otherwise
-		 * we error in probe with unsuportable ranges.
+		 * we error in probe with unsupportable ranges.
 		 */
 		if (id != PALMAS_REG_SMPS10) {
 			addr = palmas_regs_info[id].vsel_addr;
diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index efc6e72..aec2e0d 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -1800,7 +1800,7 @@ out:
  * @dev:domain device to be detect.
  * @src_dev: the device which originated BROADCAST(CHANGE).
  *
- * Add self-configuration expander suport. Suppose two expander cascading,
+ * Add self-configuration expander support. Suppose two expander cascading,
  * when the first level expander is self-configuring, hotplug the disks in
  * second level expander, BROADCAST(CHANGE) will not only be originated
  * in the second level expander, but also be originated in the first level
diff --git a/drivers/staging/comedi/drivers/usbdux.c b/drivers/staging/comedi/drivers/usbdux.c
index 848c7ec..95869cf 100644
--- a/drivers/staging/comedi/drivers/usbdux.c
+++ b/drivers/staging/comedi/drivers/usbdux.c
@@ -73,7 +73,7 @@ sampling rate. If you sample two channels you get 4kHz and so on.
  *       And loads of cleaning up, in particular streamlining the
  *       bulk transfers.
  * 1.1:  moved EP4 transfers to EP1 to make space for a PWM output on EP4
- * 1.2:  added PWM suport via EP4
+ * 1.2:  added PWM support via EP4
  * 2.0:  PWM seems to be stable and is not interfering with the other functions
  * 2.1:  changed PWM API
  * 2.2:  added firmware kernel request to fix an udev problem
diff --git a/drivers/staging/csr/netdev.c b/drivers/staging/csr/netdev.c
index 0e34020..fbff57e 100644
--- a/drivers/staging/csr/netdev.c
+++ b/drivers/staging/csr/netdev.c
@@ -100,7 +100,7 @@
 #endif /* LINUX_VERSION_CODE */
 
 
-/* Wext handler is suported only if CSR_SUPPORT_WEXT is defined */
+/* Wext handler is supported only if CSR_SUPPORT_WEXT is defined */
 #ifdef CSR_SUPPORT_WEXT
 extern struct iw_handler_def unifi_iw_handler_def;
 #endif /* CSR_SUPPORT_WEXT */
diff --git a/drivers/staging/tidspbridge/rmgr/node.c b/drivers/staging/tidspbridge/rmgr/node.c
index f17c128..73e46af 100644
--- a/drivers/staging/tidspbridge/rmgr/node.c
+++ b/drivers/staging/tidspbridge/rmgr/node.c
@@ -727,7 +727,7 @@ DBAPI node_alloc_msg_buf(struct node_object *hnode, u32 usize,
 		case 4:
 			break;
 		default:
-			/* alignment value not suportted */
+			/* alignment value not supportted */
 			status = -EPERM;
 			break;
 		}
diff --git a/drivers/usb/core/driver.c b/drivers/usb/core/driver.c
index 445455a..abf3497 100644
--- a/drivers/usb/core/driver.c
+++ b/drivers/usb/core/driver.c
@@ -243,7 +243,7 @@ static int usb_probe_device(struct device *dev)
 	/* TODO: Add real matching code */
 
 	/* The device should always appear to be in use
-	 * unless the driver suports autosuspend.
+	 * unless the driver supports autosuspend.
 	 */
 	if (!udriver->supports_autosuspend)
 		error = usb_autoresume_device(udev);
diff --git a/fs/cifs/README b/fs/cifs/README
index 22ab7b5..2d5622f 100644
--- a/fs/cifs/README
+++ b/fs/cifs/README
@@ -480,7 +480,7 @@ A partial list of the supported mount options follows:
 		Unicode on the wire.
  nomapchars     Do not translate any of these seven characters (default).
  nocase         Request case insensitive path name matching (case
-		sensitive is the default if the server suports it).
+		sensitive is the default if the server supports it).
 		(mount option "ignorecase" is identical to "nocase")
  posixpaths     If CIFS Unix extensions are supported, attempt to
 		negotiate posix path name support which allows certain
diff --git a/fs/notify/fanotify/Kconfig b/fs/notify/fanotify/Kconfig
index 7dceff0..e5f911b 100644
--- a/fs/notify/fanotify/Kconfig
+++ b/fs/notify/fanotify/Kconfig
@@ -4,7 +4,7 @@ config FANOTIFY
 	select ANON_INODES
 	default n
 	---help---
-	   Say Y here to enable fanotify suport.  fanotify is a file access
+	   Say Y here to enable fanotify support.  fanotify is a file access
 	   notification system which differs from inotify in that it sends
 	   an open file descriptor to the userspace listener along with
 	   the event.
diff --git a/include/linux/atmbr2684.h b/include/linux/atmbr2684.h
index fdb2629..d6dbf43 100644
--- a/include/linux/atmbr2684.h
+++ b/include/linux/atmbr2684.h
@@ -37,7 +37,7 @@
  */
 #define BR2684_ENCAPS_VC	(0)	/* VC-mux */
 #define BR2684_ENCAPS_LLC	(1)
-#define BR2684_ENCAPS_AUTODETECT (2)	/* Unsuported */
+#define BR2684_ENCAPS_AUTODETECT (2)	/* Unsupported */
 
 /*
  * Is this VC bridged or routed?
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index b69bdb1..c601383 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -61,7 +61,7 @@
 #define STMMAC_CSR_I_16		0xE	/* clk_csr_i/16 */
 #define STMMAC_CSR_I_18		0xF	/* clk_csr_i/18 */
 
-/* AXI DMA Burst length suported */
+/* AXI DMA Burst length supported */
 #define DMA_AXI_BLEN_4		(1 << 1)
 #define DMA_AXI_BLEN_8		(1 << 2)
 #define DMA_AXI_BLEN_16		(1 << 3)
diff --git a/net/ipv4/tcp_cong.c b/net/ipv4/tcp_cong.c
index 1432cdb..701a7f6 100644
--- a/net/ipv4/tcp_cong.c
+++ b/net/ipv4/tcp_cong.c
@@ -1,7 +1,7 @@
 /*
  * Plugable TCP congestion control support and newReno
  * congestion control.
- * Based on ideas from I/O scheduler suport and Web100.
+ * Based on ideas from I/O scheduler support and Web100.
  *
  * Copyright (C) 2005 Stephen Hemminger <shemminger@osdl.org>
  */
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index df92031..33c030c 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -597,7 +597,7 @@ static inline void drv_reset_tsf(struct ieee80211_local *local,
 
 static inline int drv_tx_last_beacon(struct ieee80211_local *local)
 {
-	int ret = 0; /* default unsuported op for less congestion */
+	int ret = 0; /* default unsupported op for less congestion */
 
 	might_sleep();
 
diff --git a/net/sctp/endpointola.c b/net/sctp/endpointola.c
index 1859e2b..bd7e6a6 100644
--- a/net/sctp/endpointola.c
+++ b/net/sctp/endpointola.c
@@ -163,7 +163,7 @@ static struct sctp_endpoint *sctp_endpoint_init(struct sctp_endpoint *ep,
 
 	list_add(&null_key->key_list, &ep->endpoint_shared_keys);
 
-	/* Allocate and initialize transorms arrays for suported HMACs. */
+	/* Allocate and initialize transorms arrays for supported HMACs. */
 	err = sctp_auth_init_hmacs(ep, gfp);
 	if (err)
 		goto nomem_hmacs;
diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 094813b..2e6b069 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -3994,7 +3994,7 @@ static sctp_ierror_t sctp_sf_authenticate(struct net *net,
 	chunk->subh.auth_hdr = auth_hdr;
 	skb_pull(chunk->skb, sizeof(struct sctp_authhdr));
 
-	/* Make sure that we suport the HMAC algorithm from the auth
+	/* Make sure that we support the HMAC algorithm from the auth
 	 * chunk.
 	 */
 	if (!sctp_auth_asoc_verify_hmac_id(asoc, auth_hdr->hmac_id))
diff --git a/sound/pci/ice1712/delta.c b/sound/pci/ice1712/delta.c
index 20c6b07..d09239c 100644
--- a/sound/pci/ice1712/delta.c
+++ b/sound/pci/ice1712/delta.c
@@ -617,7 +617,7 @@ static int __devinit snd_ice1712_delta_init(struct snd_ice1712 *ice)
 		ice->num_total_dacs = 4;	/* two AK4324 codecs */
 		break;
 	case ICE1712_SUBDEVICE_VX442:
-	case ICE1712_SUBDEVICE_DELTA66E:	/* omni not suported yet */
+	case ICE1712_SUBDEVICE_DELTA66E:	/* omni not supported yet */
 		ice->num_total_dacs = 4;
 		ice->num_total_adcs = 4;
 		break;
-- 
1.7.12.rc3.4.g91e4bfe


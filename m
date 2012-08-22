Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758916Ab2HVJkd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 05:40:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63454 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758668Ab2HVJk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 05:40:27 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: trivial@kernel.org, linux-kernel@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial] Fix typo "suppport" in various comments
Date: Wed, 22 Aug 2012 18:40:21 +0900
Message-Id: <1345628421-5378-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.12.rc3.4.g91e4bfe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix spelling typo "suppport".

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 arch/ia64/kvm/kvm-ia64.c                         | 2 +-
 drivers/net/ethernet/intel/e1000/e1000_ethtool.c | 2 +-
 drivers/net/wireless/zd1211rw/zd_chip.c          | 2 +-
 drivers/scsi/bnx2fc/bnx2fc_hwi.c                 | 2 +-
 drivers/usb/gadget/at91_udc.c                    | 2 +-
 include/linux/nl80211.h                          | 2 +-
 sound/pci/emu10k1/emu10k1_patch.c                | 2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index eac6538..e0f01ac 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -1,5 +1,5 @@
 /*
- * kvm_ia64.c: Basic KVM suppport On Itanium series processors
+ * kvm_ia64.c: Basic KVM support On Itanium series processors
  *
  *
  * 	Copyright (C) 2007, Intel Corporation.
diff --git a/drivers/net/ethernet/intel/e1000/e1000_ethtool.c b/drivers/net/ethernet/intel/e1000/e1000_ethtool.c
index 736a7d9..10daa49 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_ethtool.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_ethtool.c
@@ -1632,7 +1632,7 @@ static void e1000_get_wol(struct net_device *netdev,
 	/* apply any specific unsupported masks here */
 	switch (hw->device_id) {
 	case E1000_DEV_ID_82546GB_QUAD_COPPER_KSP3:
-		/* KSP3 does not suppport UCAST wake-ups */
+		/* KSP3 does not support UCAST wake-ups */
 		wol->supported &= ~WAKE_UCAST;
 
 		if (adapter->wol & E1000_WUFC_EX)
diff --git a/drivers/net/wireless/zd1211rw/zd_chip.c b/drivers/net/wireless/zd1211rw/zd_chip.c
index ff306d7..71ab320 100644
--- a/drivers/net/wireless/zd1211rw/zd_chip.c
+++ b/drivers/net/wireless/zd1211rw/zd_chip.c
@@ -1155,7 +1155,7 @@ int zd_chip_init_hw(struct zd_chip *chip)
 	if (r)
 		goto out;
 	/* Currently we support IEEE 802.11g for full and high speed USB.
-	 * It might be discussed, whether we should suppport pure b mode for
+	 * It might be discussed, whether we should support pure b mode for
 	 * full speed USB.
 	 */
 	r = set_mandatory_rates(chip, 1);
diff --git a/drivers/scsi/bnx2fc/bnx2fc_hwi.c b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
index 6d6eee4..ef60afa 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_hwi.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
@@ -296,7 +296,7 @@ int bnx2fc_send_session_ofld_req(struct fcoe_port *port,
 	ofld_req3.flags |= (interface->vlan_enabled <<
 			    FCOE_KWQE_CONN_OFFLOAD3_B_VLAN_FLAG_SHIFT);
 
-	/* C2_VALID and ACK flags are not set as they are not suppported */
+	/* C2_VALID and ACK flags are not set as they are not supported */
 
 
 	/* Initialize offload request 4 structure */
diff --git a/drivers/usb/gadget/at91_udc.c b/drivers/usb/gadget/at91_udc.c
index c9e66df..5349788 100644
--- a/drivers/usb/gadget/at91_udc.c
+++ b/drivers/usb/gadget/at91_udc.c
@@ -51,7 +51,7 @@
  * full speed USB controllers, including the at91rm9200 (arm920T, with MMU),
  * at91sam926x (arm926ejs, with MMU), and several no-mmu versions.
  *
- * This driver expects the board has been wired with two GPIOs suppporting
+ * This driver expects the board has been wired with two GPIOs supporting
  * a VBUS sensing IRQ, and a D+ pullup.  (They may be omitted, but the
  * testing hasn't covered such cases.)
  *
diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 2f38788..b788a07 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -2992,7 +2992,7 @@ enum nl80211_ap_sme_features {
  * @NL80211_FEATURE_INACTIVITY_TIMER: This driver takes care of freeing up
  *	the connected inactive stations in AP mode.
  * @NL80211_FEATURE_CELL_BASE_REG_HINTS: This driver has been tested
- *	to work properly to suppport receiving regulatory hints from
+ *	to work properly to support receiving regulatory hints from
  *	cellular base stations.
  */
 enum nl80211_feature_flags {
diff --git a/sound/pci/emu10k1/emu10k1_patch.c b/sound/pci/emu10k1/emu10k1_patch.c
index e10f027..662a458 100644
--- a/sound/pci/emu10k1/emu10k1_patch.c
+++ b/sound/pci/emu10k1/emu10k1_patch.c
@@ -123,7 +123,7 @@ snd_emu10k1_sample_new(struct snd_emux *rec, struct snd_sf_sample *sp,
 	offset += size;
 	data += size;
 
-#if 0 /* not suppported yet */
+#if 0 /* not supported yet */
 	/* handle reverse (or bidirectional) loop */
 	if (sp->v.mode_flags & (SNDRV_SFNT_SAMPLE_BIDIR_LOOP|SNDRV_SFNT_SAMPLE_REVERSE_LOOP)) {
 		/* copy loop in reverse */
-- 
1.7.12.rc3.4.g91e4bfe


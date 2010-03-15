Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936774Ab0COU6m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 16:58:42 -0400
Received: from mail.gmx.net ([213.165.64.20]:58108 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932266Ab0COU6M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 16:58:12 -0400
X-Authenticated: #5115406
X-Provags-ID: V01U2FsdGVkX1+XoC8ZCpqX7Os2YRxScQR0iMulKvmYWUtkleJpty
	m0/eTgnQQNxwH7
From: Thomas Weber <swirl@gmx.li>
To: linux-kernel@vger.kernel.org
Cc: Thomas Weber <swirl@gmx.li>
Subject: [PATCH 4/4] Fix typo: orginal => original
Date: Mon, 15 Mar 2010 21:58:58 +0100
Message-Id: <1268686738-28293-5-git-send-email-swirl@gmx.li>
X-Mailer: git-send-email 1.6.4.4
In-Reply-To: <1268686738-28293-1-git-send-email-swirl@gmx.li>
References: <1268686738-28293-1-git-send-email-swirl@gmx.li>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.45000000000000001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Weber <swirl@gmx.li>
---
 drivers/ata/ata_piix.c        |    2 +-
 drivers/gpu/drm/drm_bufs.c    |    2 +-
 drivers/net/smsc911x.c        |    4 ++--
 drivers/spi/spi_mpc8xxx.c     |    2 +-
 drivers/staging/rt2860/rtmp.h |    2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index c338066..b1cb8af 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -43,7 +43,7 @@
  * driver the list of errata that are relevant is below, going back to
  * PIIX4. Older device documentation is now a bit tricky to find.
  *
- * The chipsets all follow very much the same design. The orginal Triton
+ * The chipsets all follow very much the same design. The original Triton
  * series chipsets do _not_ support independant device timings, but this
  * is fixed in Triton II. With the odd mobile exception the chips then
  * change little except in gaining more modes until SATA arrives. This
diff --git a/drivers/gpu/drm/drm_bufs.c b/drivers/gpu/drm/drm_bufs.c
index 8417cc4..8475d58 100644
--- a/drivers/gpu/drm/drm_bufs.c
+++ b/drivers/gpu/drm/drm_bufs.c
@@ -960,7 +960,7 @@ int drm_addbufs_pci(struct drm_device * dev, struct drm_buf_desc * request)
 		dma->buflist[i + dma->buf_count] = &entry->buflist[i];
 	}
 
-	/* No allocations failed, so now we can replace the orginal pagelist
+	/* No allocations failed, so now we can replace the original pagelist
 	 * with the new one.
 	 */
 	if (dma->page_count) {
diff --git a/drivers/net/smsc911x.c b/drivers/net/smsc911x.c
index 4fd1d8b..eb17598 100644
--- a/drivers/net/smsc911x.c
+++ b/drivers/net/smsc911x.c
@@ -737,7 +737,7 @@ static void smsc911x_phy_adjust_link(struct net_device *dev)
 			SMSC_TRACE(HW, "configuring for carrier OK");
 			if ((pdata->gpio_orig_setting & GPIO_CFG_LED1_EN_) &&
 			    (!pdata->using_extphy)) {
-				/* Restore orginal GPIO configuration */
+				/* Restore original GPIO configuration */
 				pdata->gpio_setting = pdata->gpio_orig_setting;
 				smsc911x_reg_write(pdata, GPIO_CFG,
 					pdata->gpio_setting);
@@ -751,7 +751,7 @@ static void smsc911x_phy_adjust_link(struct net_device *dev)
 			if ((pdata->gpio_setting & GPIO_CFG_LED1_EN_) &&
 			    (!pdata->using_extphy)) {
 				/* Force 10/100 LED off, after saving
-				 * orginal GPIO configuration */
+				 * original GPIO configuration */
 				pdata->gpio_orig_setting = pdata->gpio_setting;
 
 				pdata->gpio_setting &= ~GPIO_CFG_LED1_EN_;
diff --git a/drivers/spi/spi_mpc8xxx.c b/drivers/spi/spi_mpc8xxx.c
index 4f0cc9d..56efdfe 100644
--- a/drivers/spi/spi_mpc8xxx.c
+++ b/drivers/spi/spi_mpc8xxx.c
@@ -639,7 +639,7 @@ static int mpc8xxx_spi_setup(struct spi_device *spi)
 	}
 	mpc8xxx_spi = spi_master_get_devdata(spi->master);
 
-	hw_mode = cs->hw_mode; /* Save orginal settings */
+	hw_mode = cs->hw_mode; /* Save original settings */
 	cs->hw_mode = mpc8xxx_spi_read_reg(&mpc8xxx_spi->base->mode);
 	/* mask out bits we are going to set */
 	cs->hw_mode &= ~(SPMODE_CP_BEGIN_EDGECLK | SPMODE_CI_INACTIVEHIGH
diff --git a/drivers/staging/rt2860/rtmp.h b/drivers/staging/rt2860/rtmp.h
index 4401a55..9224dc4 100644
--- a/drivers/staging/rt2860/rtmp.h
+++ b/drivers/staging/rt2860/rtmp.h
@@ -346,7 +346,7 @@ struct rt_rtmp_sg_list {
 #define LEAP_ON(_p)                 (((_p)->StaCfg.LeapAuthMode) == CISCO_AuthModeLEAP)
 #define LEAP_CCKM_ON(_p)            ((((_p)->StaCfg.LeapAuthMode) == CISCO_AuthModeLEAP) && ((_p)->StaCfg.LeapAuthInfo.CCKM == TRUE))
 
-/* if orginal Ethernet frame contains no LLC/SNAP, then an extra LLC/SNAP encap is required */
+/* if original Ethernet frame contains no LLC/SNAP, then an extra LLC/SNAP encap is required */
 #define EXTRA_LLCSNAP_ENCAP_FROM_PKT_START(_pBufVA, _pExtraLlcSnapEncap)		\
 {																\
 	if (((*(_pBufVA + 12) << 8) + *(_pBufVA + 13)) > 1500)		\
-- 
1.6.4.4


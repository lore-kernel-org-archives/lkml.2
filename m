Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936751Ab0COU6O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 16:58:14 -0400
Received: from mail.gmx.net ([213.165.64.20]:56819 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932260Ab0COU6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 16:58:10 -0400
X-Authenticated: #5115406
X-Provags-ID: V01U2FsdGVkX18eAwBE62Mea9zMHbL4ub40D/jRqQyph9csZ/tjKO
	l/RWisZ+sPD3G1
From: Thomas Weber <swirl@gmx.li>
To: linux-kernel@vger.kernel.org
Cc: Thomas Weber <swirl@gmx.li>
Subject: [PATCH 2/4] Fix typo: udpate => update
Date: Mon, 15 Mar 2010 21:58:56 +0100
Message-Id: <1268686738-28293-3-git-send-email-swirl@gmx.li>
X-Mailer: git-send-email 1.6.4.4
In-Reply-To: <1268686738-28293-1-git-send-email-swirl@gmx.li>
References: <1268686738-28293-1-git-send-email-swirl@gmx.li>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.42999999999999999
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Weber <swirl@gmx.li>
---
 Documentation/kbuild/kconfig.txt            |    2 +-
 drivers/firewire/ohci.c                     |    2 +-
 drivers/infiniband/hw/ipath/ipath_iba6110.c |    2 +-
 drivers/infiniband/hw/ipath/ipath_iba6120.c |    4 ++--
 drivers/infiniband/hw/ipath/ipath_iba7220.c |    2 +-
 drivers/isdn/hisax/hfc4s8s_l1.c             |    2 +-
 drivers/staging/rtl8187se/r8180_core.c      |    4 ++--
 drivers/staging/rtl8187se/r8180_dm.c        |    2 +-
 drivers/staging/rtl8187se/r8185b_init.c     |    2 +-
 fs/jfs/jfs_dmap.c                           |    2 +-
 10 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/Documentation/kbuild/kconfig.txt b/Documentation/kbuild/kconfig.txt
index 49efae7..b2cb16e 100644
--- a/Documentation/kbuild/kconfig.txt
+++ b/Documentation/kbuild/kconfig.txt
@@ -96,7 +96,7 @@ Environment variables for 'silentoldconfig'
 KCONFIG_NOSILENTUPDATE
 --------------------------------------------------
 If this variable has a non-blank value, it prevents silent kernel
-config udpates (requires explicit updates).
+config updates (requires explicit updates).
 
 KCONFIG_AUTOCONFIG
 --------------------------------------------------
diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index 75dc698..8e180a2 100644
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -1342,7 +1342,7 @@ static void bus_reset_tasklet(unsigned long data)
 	 * was set up before this reset, the old one is now no longer
 	 * in use and we can free it. Update the config rom pointers
 	 * to point to the current config rom and clear the
-	 * next_config_rom pointer so a new udpate can take place.
+	 * next_config_rom pointer so a new update can take place.
 	 */
 
 	if (ohci->next_config_rom != NULL) {
diff --git a/drivers/infiniband/hw/ipath/ipath_iba6110.c b/drivers/infiniband/hw/ipath/ipath_iba6110.c
index 37d12e5..1d7aea1 100644
--- a/drivers/infiniband/hw/ipath/ipath_iba6110.c
+++ b/drivers/infiniband/hw/ipath/ipath_iba6110.c
@@ -1474,7 +1474,7 @@ static void ipath_ht_quiet_serdes(struct ipath_devdata *dd)
 /**
  * ipath_pe_put_tid - write a TID in chip
  * @dd: the infinipath device
- * @tidptr: pointer to the expected TID (in chip) to udpate
+ * @tidptr: pointer to the expected TID (in chip) to update
  * @tidtype: RCVHQ_RCV_TYPE_EAGER (1) for eager, RCVHQ_RCV_TYPE_EXPECTED (0) for expected
  * @pa: physical address of in memory buffer; ipath_tidinvalid if freeing
  *
diff --git a/drivers/infiniband/hw/ipath/ipath_iba6120.c b/drivers/infiniband/hw/ipath/ipath_iba6120.c
index fbf8c53..4b4a30b 100644
--- a/drivers/infiniband/hw/ipath/ipath_iba6120.c
+++ b/drivers/infiniband/hw/ipath/ipath_iba6120.c
@@ -1328,7 +1328,7 @@ bail:
 /**
  * ipath_pe_put_tid - write a TID in chip
  * @dd: the infinipath device
- * @tidptr: pointer to the expected TID (in chip) to udpate
+ * @tidptr: pointer to the expected TID (in chip) to update
  * @tidtype: RCVHQ_RCV_TYPE_EAGER (1) for eager, RCVHQ_RCV_TYPE_EXPECTED (0) for expected
  * @pa: physical address of in memory buffer; ipath_tidinvalid if freeing
  *
@@ -1394,7 +1394,7 @@ static void ipath_pe_put_tid(struct ipath_devdata *dd, u64 __iomem *tidptr,
 /**
  * ipath_pe_put_tid_2 - write a TID in chip, Revision 2 or higher
  * @dd: the infinipath device
- * @tidptr: pointer to the expected TID (in chip) to udpate
+ * @tidptr: pointer to the expected TID (in chip) to update
  * @tidtype: RCVHQ_RCV_TYPE_EAGER (1) for eager, RCVHQ_RCV_TYPE_EXPECTED (0) for expected
  * @pa: physical address of in memory buffer; ipath_tidinvalid if freeing
  *
diff --git a/drivers/infiniband/hw/ipath/ipath_iba7220.c b/drivers/infiniband/hw/ipath/ipath_iba7220.c
index a805402..34b778e 100644
--- a/drivers/infiniband/hw/ipath/ipath_iba7220.c
+++ b/drivers/infiniband/hw/ipath/ipath_iba7220.c
@@ -1738,7 +1738,7 @@ bail:
 /**
  * ipath_7220_put_tid - write a TID to the chip
  * @dd: the infinipath device
- * @tidptr: pointer to the expected TID (in chip) to udpate
+ * @tidptr: pointer to the expected TID (in chip) to update
  * @tidtype: 0 for eager, 1 for expected
  * @pa: physical address of in memory buffer; ipath_tidinvalid if freeing
  *
diff --git a/drivers/isdn/hisax/hfc4s8s_l1.c b/drivers/isdn/hisax/hfc4s8s_l1.c
index ab98e13..7ea0d07 100644
--- a/drivers/isdn/hisax/hfc4s8s_l1.c
+++ b/drivers/isdn/hisax/hfc4s8s_l1.c
@@ -309,7 +309,7 @@ wait_busy(hfc4s8s_hw * a)
 
 /******************************************************/
 /* function to read critical counter registers that   */
-/* may be udpated by the chip during read             */
+/* may be updated by the chip during read             */
 /******************************************************/
 static u_char
 Read_hfc8_stable(hfc4s8s_hw * hw, int reg)
diff --git a/drivers/staging/rtl8187se/r8180_core.c b/drivers/staging/rtl8187se/r8180_core.c
index b1757ac..54bbf41 100644
--- a/drivers/staging/rtl8187se/r8180_core.c
+++ b/drivers/staging/rtl8187se/r8180_core.c
@@ -2364,7 +2364,7 @@ void rtl8180_wmm_param_update(struct work_struct * work)
 				u8		u1bAIFS;
 				u32		u4bAcParam;
 				pAcParam = (PAC_PARAM)(&AcParam);
-				// Retrive paramters to udpate.
+				// Retrive paramters to update.
 				u1bAIFS = pAcParam->f.AciAifsn.f.AIFSN *(((mode&IEEE_G) == IEEE_G)?9:20) + aSifsTime;
 				u4bAcParam = ((((u32)(pAcParam->f.TXOPLimit))<<AC_PARAM_TXOP_LIMIT_OFFSET)|
 					      (((u32)(pAcParam->f.Ecw.f.ECWmax))<<AC_PARAM_ECW_MAX_OFFSET)|
@@ -2400,7 +2400,7 @@ void rtl8180_wmm_param_update(struct work_struct * work)
 			u8		u1bAIFS;
 			u32		u4bAcParam;
 
-			// Retrive paramters to udpate.
+			// Retrive paramters to update.
 			eACI = pAcParam->f.AciAifsn.f.ACI;
 			//Mode G/A: slotTimeTimer = 9; Mode B: 20
 			u1bAIFS = pAcParam->f.AciAifsn.f.AIFSN * (((mode&IEEE_G) == IEEE_G)?9:20) + aSifsTime;
diff --git a/drivers/staging/rtl8187se/r8180_dm.c b/drivers/staging/rtl8187se/r8180_dm.c
index fc49078..462f46a 100644
--- a/drivers/staging/rtl8187se/r8180_dm.c
+++ b/drivers/staging/rtl8187se/r8180_dm.c
@@ -35,7 +35,7 @@ bool CheckHighPower(struct net_device *dev)
 //		See also DoRxHighPower() and SetTxPowerLevel8185() for reference.
 //
 //	Note:
-//		The reason why we udpate Tx power level here instead of DoRxHighPower()
+//		The reason why we update Tx power level here instead of DoRxHighPower()
 //		is the number of IO to change Tx power is much more than channel TR switch
 //		and they are related to OFDM and MAC registers.
 //		So, we don't want to update it so frequently in per-Rx packet base.
diff --git a/drivers/staging/rtl8187se/r8185b_init.c b/drivers/staging/rtl8187se/r8185b_init.c
index a0ece1f..519383e 100644
--- a/drivers/staging/rtl8187se/r8185b_init.c
+++ b/drivers/staging/rtl8187se/r8185b_init.c
@@ -1128,7 +1128,7 @@ ActUpdateChannelAccessSetting(
 				u8		u1bAIFS;
 				u32		u4bAcParam;
 
-				// Retrive paramters to udpate.
+				// Retrive paramters to update.
 				eACI = pAcParam->f.AciAifsn.f.ACI;
 				u1bAIFS = pAcParam->f.AciAifsn.f.AIFSN * ChnlAccessSetting->SlotTimeTimer + aSifsTime;
 				u4bAcParam = (	(((u32)(pAcParam->f.TXOPLimit)) << AC_PARAM_TXOP_LIMIT_OFFSET)	|
diff --git a/fs/jfs/jfs_dmap.c b/fs/jfs/jfs_dmap.c
index d9b031c..d13b930 100644
--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -2437,7 +2437,7 @@ dbAdjCtl(struct bmap * bmp, s64 blkno, int newval, int alloc, int level)
 
 	/* check if this is a control page update for an allocation.
 	 * if so, update the leaf to reflect the new leaf value using
-	 * dbSplit(); otherwise (deallocation), use dbJoin() to udpate
+	 * dbSplit(); otherwise (deallocation), use dbJoin() to update
 	 * the leaf with the new value.  in addition to updating the
 	 * leaf, dbSplit() will also split the binary buddy system of
 	 * the leaves, if required, and bubble new values within the
-- 
1.6.4.4


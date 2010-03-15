Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936785Ab0COU6z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 16:58:55 -0400
Received: from mail.gmx.net ([213.165.64.20]:57445 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932738Ab0COU6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 16:58:11 -0400
X-Authenticated: #5115406
X-Provags-ID: V01U2FsdGVkX18ZGMV8Vd0ZbIrj55wVgS/OWeuuvxlcfN6PWCJOiw
	oOBipIrwJ/6F8C
From: Thomas Weber <swirl@gmx.li>
To: linux-kernel@vger.kernel.org
Cc: Thomas Weber <swirl@gmx.li>
Subject: [PATCH 3/4] Fix typo: paramters => parameters
Date: Mon, 15 Mar 2010 21:58:57 +0100
Message-Id: <1268686738-28293-4-git-send-email-swirl@gmx.li>
X-Mailer: git-send-email 1.6.4.4
In-Reply-To: <1268686738-28293-1-git-send-email-swirl@gmx.li>
References: <1268686738-28293-1-git-send-email-swirl@gmx.li>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.46000000000000002
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Weber <swirl@gmx.li>
---
 drivers/media/dvb/dvb-usb/friio-fe.c         |    2 +-
 drivers/scsi/bfa/include/defs/bfa_defs_cee.h |    2 +-
 drivers/staging/rtl8187se/r8180_core.c       |    4 ++--
 drivers/staging/rtl8187se/r8185b_init.c      |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/friio-fe.c b/drivers/media/dvb/dvb-usb/friio-fe.c
index d14bd22..93c21dd 100644
--- a/drivers/media/dvb/dvb-usb/friio-fe.c
+++ b/drivers/media/dvb/dvb-usb/friio-fe.c
@@ -300,7 +300,7 @@ static int jdvbt90502_set_frontend(struct dvb_frontend *fe,
 				   struct dvb_frontend_parameters *p)
 {
 	/**
-	 * NOTE: ignore all the paramters except frequency.
+	 * NOTE: ignore all the parameters except frequency.
 	 *       others should be fixed to the proper value for ISDB-T,
 	 *       but don't check here.
 	 */
diff --git a/drivers/scsi/bfa/include/defs/bfa_defs_cee.h b/drivers/scsi/bfa/include/defs/bfa_defs_cee.h
index 520a22f..6217eec 100644
--- a/drivers/scsi/bfa/include/defs/bfa_defs_cee.h
+++ b/drivers/scsi/bfa/include/defs/bfa_defs_cee.h
@@ -54,7 +54,7 @@ struct bfa_cee_lldp_str_s {
 };
 
 
-/* LLDP paramters */
+/* LLDP parameters */
 struct bfa_cee_lldp_cfg_s {
 	struct bfa_cee_lldp_str_s chassis_id;
 	struct bfa_cee_lldp_str_s port_id;
diff --git a/drivers/staging/rtl8187se/r8180_core.c b/drivers/staging/rtl8187se/r8180_core.c
index 54bbf41..7f431ef 100644
--- a/drivers/staging/rtl8187se/r8180_core.c
+++ b/drivers/staging/rtl8187se/r8180_core.c
@@ -2364,7 +2364,7 @@ void rtl8180_wmm_param_update(struct work_struct * work)
 				u8		u1bAIFS;
 				u32		u4bAcParam;
 				pAcParam = (PAC_PARAM)(&AcParam);
-				// Retrive paramters to update.
+				// Retrive parameters to update.
 				u1bAIFS = pAcParam->f.AciAifsn.f.AIFSN *(((mode&IEEE_G) == IEEE_G)?9:20) + aSifsTime;
 				u4bAcParam = ((((u32)(pAcParam->f.TXOPLimit))<<AC_PARAM_TXOP_LIMIT_OFFSET)|
 					      (((u32)(pAcParam->f.Ecw.f.ECWmax))<<AC_PARAM_ECW_MAX_OFFSET)|
@@ -2400,7 +2400,7 @@ void rtl8180_wmm_param_update(struct work_struct * work)
 			u8		u1bAIFS;
 			u32		u4bAcParam;
 
-			// Retrive paramters to update.
+			// Retrive parameters to update.
 			eACI = pAcParam->f.AciAifsn.f.ACI;
 			//Mode G/A: slotTimeTimer = 9; Mode B: 20
 			u1bAIFS = pAcParam->f.AciAifsn.f.AIFSN * (((mode&IEEE_G) == IEEE_G)?9:20) + aSifsTime;
diff --git a/drivers/staging/rtl8187se/r8185b_init.c b/drivers/staging/rtl8187se/r8185b_init.c
index 519383e..f22275e 100644
--- a/drivers/staging/rtl8187se/r8185b_init.c
+++ b/drivers/staging/rtl8187se/r8185b_init.c
@@ -1128,7 +1128,7 @@ ActUpdateChannelAccessSetting(
 				u8		u1bAIFS;
 				u32		u4bAcParam;
 
-				// Retrive paramters to update.
+				// Retrive parameters to update.
 				eACI = pAcParam->f.AciAifsn.f.ACI;
 				u1bAIFS = pAcParam->f.AciAifsn.f.AIFSN * ChnlAccessSetting->SlotTimeTimer + aSifsTime;
 				u4bAcParam = (	(((u32)(pAcParam->f.TXOPLimit)) << AC_PARAM_TXOP_LIMIT_OFFSET)	|
-- 
1.6.4.4


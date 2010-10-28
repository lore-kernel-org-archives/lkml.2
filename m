Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934561Ab0J1Vqx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 17:46:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:51990 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933866Ab0J1Vqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 17:46:44 -0400
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=6ThQLmJjoywA:10 a=kj9zAlcOel0A:10 a=mpMdnlmFKti1S5SNY1DT+A==:17 a=yQdBAQUQAAAA:8 a=2C6YHBdLAAAA:8 a=deDR3FDtIebAJckgX_UA:9 a=U4CccYimC4Z_lukdnyYGU6epDs8A:4 a=CjuIK1q_8ugA:10 a=IcxpeKGZWnEA:10 a=mJMriH8CDpcA:10 a=mpMdnlmFKti1S5SNY1DT+A==:117
X-Cloudmark-Score: 0
X-Originating-IP: 65.28.92.85
Date: Thu, 28 Oct 2010 16:47:03 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] staging: r8712u: Fix sparse message
Message-ID: <4cc9ef57.olkJXiwQEtL/lNA3%Larry.Finger@lwfinger.net>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From b57eb713ef7d36b2fe10ec83a989ba1845e098b6 Mon Sep 17 00:00:00 2001
From: Larry Finger <Larry.Finger@lwfinger.net>
Date: Tue, 26 Oct 2010 11:02:25 -0500
Subject: [PATCH 2/2] staging: r8712u: Fix sparse message

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/staging/rtl8712/TODO                  |    1 -
 drivers/staging/rtl8712/rtl871x_ioctl_linux.c |    1 +
 drivers/staging/rtl8712/rtl871x_mp_ioctl.c    |    2 --
 drivers/staging/rtl8712/rtl871x_mp_ioctl.h    |    2 +-
 4 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rtl8712/TODO b/drivers/staging/rtl8712/TODO
index ed22b0b..d8dfe5b 100644
--- a/drivers/staging/rtl8712/TODO
+++ b/drivers/staging/rtl8712/TODO
@@ -3,7 +3,6 @@ TODO:
 - switch to use LIB80211
 - switch to use MAC80211
 - checkpatch.pl fixes - only a few remain
-- sparse fixes
 
 Please send any patches to Greg Kroah-Hartman <greg@kroah.com>,
 Larry Finger <Larry.Finger@lwfinger.net> and
diff --git a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
index 1529239..f4353eb 100644
--- a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
+++ b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
@@ -27,6 +27,7 @@
  ******************************************************************************/
 
 #define _RTL871X_IOCTL_LINUX_C_
+#define _RTL871X_MP_IOCTL_C_
 
 #include "osdep_service.h"
 #include "drv_types.h"
diff --git a/drivers/staging/rtl8712/rtl871x_mp_ioctl.c b/drivers/staging/rtl8712/rtl871x_mp_ioctl.c
index d60aaa9..5eb461b 100644
--- a/drivers/staging/rtl8712/rtl871x_mp_ioctl.c
+++ b/drivers/staging/rtl8712/rtl871x_mp_ioctl.c
@@ -26,8 +26,6 @@
  *
  ******************************************************************************/
 
-#define _RTL871X_MP_IOCTL_C_
-
 #include "osdep_service.h"
 #include "drv_types.h"
 #include "mlme_osdep.h"
diff --git a/drivers/staging/rtl8712/rtl871x_mp_ioctl.h b/drivers/staging/rtl8712/rtl871x_mp_ioctl.h
index 2225bd1..fdd2278 100644
--- a/drivers/staging/rtl8712/rtl871x_mp_ioctl.h
+++ b/drivers/staging/rtl8712/rtl871x_mp_ioctl.h
@@ -373,7 +373,7 @@ unsigned int mp_ioctl_xmit_packet_hdl(struct oid_par_priv *poid_par_priv);
 #ifdef _RTL871X_MP_IOCTL_C_ /* CAUTION!!! */
 /* This ifdef _MUST_ be left in!! */
 
-struct mp_ioctl_handler mp_ioctl_hdl[] = {
+static struct mp_ioctl_handler mp_ioctl_hdl[] = {
 	{sizeof(u32), oid_rt_pro_start_test_hdl,
 			     OID_RT_PRO_START_TEST},/*0*/
 	{sizeof(u32), oid_rt_pro_stop_test_hdl,
-- 
1.7.1


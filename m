Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214Ab1ANUyd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 15:54:33 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:63722 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138Ab1ANUya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 15:54:30 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=aCcZZZ7-t8AA:10 a=kj9zAlcOel0A:10 a=mpMdnlmFKti1S5SNY1DT+A==:17 a=yQdBAQUQAAAA:8 a=CYy34BVgEvKPex3tj1gA:9 a=8urQqozHwSBgh4ewbKegHeSTd20A:4 a=CjuIK1q_8ugA:10 a=IcxpeKGZWnEA:10 a=mpMdnlmFKti1S5SNY1DT+A==:117
X-Cloudmark-Score: 0
X-Originating-IP: 65.28.92.85
Date: Fri, 14 Jan 2011 14:54:13 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: florian.c.schilhabel@googlemail.com, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] staging: r8712u: Fix sparse message
Message-ID: <4d30b7f5.U8aY0q3GHQ/vnBVI%Larry.Finger@lwfinger.net>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/staging/rtl8712/rtl871x_ioctl_linux.c |    1 +
 drivers/staging/rtl8712/rtl871x_mp_ioctl.c    |    2 --
 drivers/staging/rtl8712/rtl871x_mp_ioctl.h    |    2 +-
 3 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
index 685a7b1..0d288c1 100644
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


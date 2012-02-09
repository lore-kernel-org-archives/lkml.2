Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932201Ab2BIUMR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 15:12:17 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:56939 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932107Ab2BIUMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 15:12:15 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19hJThA4CphSd4C8xYJPWJq87dC6IqK8BseC5HrWY
	H3s2ZHNx15PlA1
From: Peter Huewe <peterhuewe@gmx.de>
To: gregkh@linuxfoundation.org
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 1/7] staging/xgifb: Include sis initdef.h header
Date: Thu,  9 Feb 2012 21:11:43 +0100
Message-Id: <1328818309-5103-2-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1328818309-5103-1-git-send-email-peterhuewe@gmx.de>
References: <1328818309-5103-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch includes the initdef.h header from the sis driver.
Since the xgi driver used to redefine a lot of stuff from the sis
driver, we can simply include the headers of the sis driver itself, so
we can remove duplicated stuff later on.

In order to include the initdef.h we have to rename the header guards.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/xgifb/vb_def.h |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/xgifb/vb_def.h b/drivers/staging/xgifb/vb_def.h
index 5beeef9..0472c86 100644
--- a/drivers/staging/xgifb/vb_def.h
+++ b/drivers/staging/xgifb/vb_def.h
@@ -1,7 +1,8 @@
 /* $XFree86: xc/programs/Xserver/hw/xfree86/drivers/xgi/initdef.h
  * ,v 1.4 2000/12/02 01:16:17 dawes Exp $*/
-#ifndef _INITDEF_
-#define _INITDEF_
+#ifndef _VB_DEF_
+#define _VB_DEF_
+#include "../../video/sis/initdef.h"
 
 #define VB_XGI301C      0x0020 /* for 301C */
 /*end 301b*/
-- 
1.7.3.4


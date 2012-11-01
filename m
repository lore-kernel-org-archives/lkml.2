Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131Ab2KAFrV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 01:47:21 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:62946 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822Ab2KAFrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 01:47:19 -0400
MIME-Version: 1.0
Date: Thu, 1 Nov 2012 13:47:19 +0800
Message-ID: <CAPgLHd8vjxZWpmB3VhK7sfWcri5=6++WfJo6f4-QxX4mEDKFjA@mail.gmail.com>
Subject: [PATCH -next] Staging: silicom: bypasslib: remove unused including <linux/version.h>
From: Wei Yongjun <weiyj.lk@gmail.com>
To: gregkh@linuxfoundation.org
Cc: yongjun_wei@trendmicro.com.cn, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Remove including <linux/version.h> that don't need it.

dpatch engine is used to auto generate this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/staging/silicom/bypasslib/bplibk.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/silicom/bypasslib/bplibk.h b/drivers/staging/silicom/bypasslib/bplibk.h
index a726d90..d8c1d27 100644
--- a/drivers/staging/silicom/bypasslib/bplibk.h
+++ b/drivers/staging/silicom/bypasslib/bplibk.h
@@ -15,7 +15,6 @@
 
 #include "bp_ioctl.h"
 #include "libbp_sd.h"
-#include <linux/version.h>
 
 #define IF_NAME            "eth"
 #define SILICOM_VID        0x1374



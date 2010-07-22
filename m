Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725Ab0GVT7a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 15:59:30 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34887 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755091Ab0GVT72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 15:59:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:content-type:date:message-id
         :mime-version:x-mailer:content-transfer-encoding;
        b=c5o0jgh7F9YzGUkcuhSTyCitU+UVCWuh3JhaTM2QNIizKt4WkB1FFP5mnZYJ46I5ez
         lEJcnFvflQieByiqibtXmIMrT6VFYo7S9uYZT386vpt2pWsuGeBC6+WLnIDrODxlj7H9
         wZCmeBei1Qb/GEuH4trMyHkDlgAaA02Uwx/VU=
Subject: [PATCH 1/2] Staging: dt3155: Change include to linux header
From: Joe Eloff <kagen101@gmail.com>
Reply-To: kagen101@gmail.com
To: Greg Kroah-Hartman <gregkh@suse.de>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Simon Horman <horms@verge.net.au>
Cc: devel <devel@driverdev.osuosl.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Jul 2010 21:59:10 +0200
Message-ID: <1279828750.759.2.camel@dermezel>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 434257d406094235c5c5020a68f34e2beb658e51 Mon Sep 17 00:00:00 2001
From: Joe Eloff <kagen101@gmail.com>
Date: Thu, 22 Jul 2010 20:26:25 +0200
Subject: [PATCH 1/2] Staging: dt3155: Change include to linux header

Changed <asm/uaccess.h> to <linux/uaccess.h>
Signed-off-by: Joe Eloff <kagen101@gmail.com>
---
 drivers/staging/dt3155/dt3155_drv.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/dt3155/dt3155_drv.c b/drivers/staging/dt3155/dt3155_drv.c
index fed7e62..1d6858c 100644
--- a/drivers/staging/dt3155/dt3155_drv.c
+++ b/drivers/staging/dt3155/dt3155_drv.c
@@ -66,7 +66,7 @@ extern void printques(int);
 #include <linux/smp_lock.h>
 #include <linux/io.h>
 
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 #include "dt3155.h"
 #include "dt3155_drv.h"
-- 
1.6.3.3




Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751165Ab1IUVHm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 17:07:42 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:56393 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751051Ab1IUVHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 17:07:41 -0400
Message-ID: <4E7A521B.50104@xenotime.net>
Date: Wed, 21 Sep 2011 14:07:39 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110907 SUSE/3.1.14 Thunderbird/3.1.14
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: [PATCH -next] bcma: main.c and driver_mips.c need linux/export.h
References: <20110920173102.d38155c7defbbc29beaae7c0@canb.auug.org.au>	<4E78CFC0.4020003@xenotime.net>	<CACna6rxGrd-ORWZrc0xsAOKptU_Xj3eGh9qSfX9vJYCPTZrCRg@mail.gmail.com>	<4E78FCDB.1010002@xenotime.net>	<CACna6rywFitSNkkwo6tNy887vdsoyHG5Cadk6Bb8_qBJ+gc42w@mail.gmail.com>	<4E7A084C.3000304@xenotime.net> <CACna6ryNw+YgTiO5dBSGcTfUabM_yO0LaSsbGpC_X6JrQudnBQ@mail.gmail.com>
In-Reply-To: <CACna6ryNw+YgTiO5dBSGcTfUabM_yO0LaSsbGpC_X6JrQudnBQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

main.c and driver_mips.c use EXPORT_SYMBOL() etc.
so they should include <linux/export.h>.

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 drivers/bcma/driver_mips.c |    1 +
 drivers/bcma/main.c        |    1 +
 2 files changed, 2 insertions(+)

--- next-2011-0921.orig/drivers/bcma/driver_mips.c
+++ next-2011-0921/drivers/bcma/driver_mips.c
@@ -14,6 +14,7 @@
 
 #include <linux/bcma/bcma.h>
 
+#include <linux/export.h>
 #include <linux/serial.h>
 #include <linux/serial_core.h>
 #include <linux/serial_reg.h>
--- next-2011-0921.orig/drivers/bcma/main.c
+++ next-2011-0921/drivers/bcma/main.c
@@ -7,6 +7,7 @@
 
 #include "bcma_private.h"
 #include <linux/module.h>
+#include <linux/export.h>
 #include <linux/bcma/bcma.h>
 #include <linux/slab.h>
 

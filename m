Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751723Ab1ITUvn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 16:51:43 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:49577 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751164Ab1ITUvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 16:51:41 -0400
Message-ID: <4E78FCDB.1010002@xenotime.net>
Date: Tue, 20 Sep 2011 13:51:39 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110907 SUSE/3.1.14 Thunderbird/3.1.14
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: [PATCH -next v2] bcma: driver_chipcommon_pmu.c needs linux/export.h
References: <20110920173102.d38155c7defbbc29beaae7c0@canb.auug.org.au>	<4E78CFC0.4020003@xenotime.net> <CACna6rxGrd-ORWZrc0xsAOKptU_Xj3eGh9qSfX9vJYCPTZrCRg@mail.gmail.com>
In-Reply-To: <CACna6rxGrd-ORWZrc0xsAOKptU_Xj3eGh9qSfX9vJYCPTZrCRg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

bcma/driver_chipcommon_pmu.c needs to include <linux/export.h>
to fix these warnings:

drivers/bcma/driver_chipcommon_pmu.c:27:1: warning: data definition has no type or storage class
drivers/bcma/driver_chipcommon_pmu.c:27:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
drivers/bcma/driver_chipcommon_pmu.c:27:1: warning: parameter names (without types) in function declaration
drivers/bcma/driver_chipcommon_pmu.c:36:1: warning: data definition has no type or storage class
drivers/bcma/driver_chipcommon_pmu.c:36:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
drivers/bcma/driver_chipcommon_pmu.c:36:1: warning: parameter names (without types) in function declaration
drivers/bcma/driver_chipcommon_pmu.c:45:1: warning: data definition has no type or storage class
drivers/bcma/driver_chipcommon_pmu.c:45:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
drivers/bcma/driver_chipcommon_pmu.c:45:1: warning: parameter names (without types) in function declaration
drivers/bcma/driver_chipcommon_pmu.c:54:1: warning: data definition has no type or storage class
drivers/bcma/driver_chipcommon_pmu.c:54:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
drivers/bcma/driver_chipcommon_pmu.c:54:1: warning: parameter names (without types) in function declaration

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 drivers/bcma/driver_chipcommon_pmu.c |    1 +
 1 file changed, 1 insertion(+)

--- next-2011-0920.orig/drivers/bcma/driver_chipcommon_pmu.c
+++ next-2011-0920/drivers/bcma/driver_chipcommon_pmu.c
@@ -9,6 +9,7 @@
  */
 
 #include "bcma_private.h"
+#include <linux/export.h>
 #include <linux/bcma/bcma.h>
 
 static u32 bcma_chipco_pll_read(struct bcma_drv_cc *cc, u32 offset)

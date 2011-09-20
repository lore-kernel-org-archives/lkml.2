Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129Ab1ITRjS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 13:39:18 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:42434 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751180Ab1ITRjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 13:39:15 -0400
Message-ID: <4E78CFC0.4020003@xenotime.net>
Date: Tue, 20 Sep 2011 10:39:12 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110907 SUSE/3.1.14 Thunderbird/3.1.14
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        zajec5@gmail.com,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -next] bcma: needs export.h
References: <20110920173102.d38155c7defbbc29beaae7c0@canb.auug.org.au>
In-Reply-To: <20110920173102.d38155c7defbbc29beaae7c0@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

bcma/driver_chipcommon_pmu.c needs to include <linux/export.h>,
so add it to the headers that are included by bcma_private.h.

Fixes these warnings:

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
 drivers/bcma/bcma_private.h |    1 +
 1 file changed, 1 insertion(+)

--- next-2011-0920.orig/drivers/bcma/bcma_private.h
+++ next-2011-0920/drivers/bcma/bcma_private.h
@@ -7,6 +7,7 @@
 
 #include <linux/bcma/bcma.h>
 #include <linux/delay.h>
+#include <linux/export.h>
 
 #define BCMA_CORE_SIZE		0x1000
 


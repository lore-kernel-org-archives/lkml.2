Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095Ab2GBBRS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 21:17:18 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:36739 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752434Ab2GBBRQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 21:17:16 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "arnd@arndb.de" <arnd@arndb.de>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mathieu.poirier@linaro.org" <mathieu.poirier@linaro.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: [PATCH] ethernet: add export.h in davinci_cpdma.c
Thread-Topic: [PATCH] ethernet: add export.h in davinci_cpdma.c
Thread-Index: Ac1X8Funclewraz+TkKfQvom2CLpBg==
Date: Mon, 2 Jul 2012 01:17:03 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998FCAAB@DQHE02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-hashedpuzzle: F5aa Im3h KC89 S8JF U83r VjTc bbQu jMib rrjX sAWG t4/u
 3ZDI 7dLN /xdU AAO4nA==
 AAVc4g==;6;YQByAG4AZABAAGEAcgBuAGQAYgAuAGQAZQA7AGQAYQB2AGUAbQBAAGQAYQB2AGUAbQBsAG8AZgB0AC4AbgBlAHQAOwBsAGkAbgB1AHgALQBrAGUAcgBuAGUAbABAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnADsAbABpAG4AdQB4AC0AbwBtAGEAcABAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnADsAbQBhAHQAaABpAGUAdQAuAHAAbwBpAHIAaQBlAHIAQABsAGkAbgBhAHIAbwAuAG8AcgBnADsAdABvAG4AeQBAAGEAdABvAG0AaQBkAGUALgBjAG8AbQA=;Sosha1_v1;7;{B209E57F-2807-422B-932B-7804649460AC};bQBpAGwAbwAuAGsAaQBtAEAAdABpAC4AYwBvAG0A;Mon,
 02 Jul 2012 01:16:50
 GMT;WwBQAEEAVABDAEgAXQAgAGUAdABoAGUAcgBuAGUAdAA6ACAAYQBkAGQAIABlAHgAcABvAHIAdAAuAGgAIABpAG4AIABkAGEAdgBpAG4AYwBpAF8AYwBwAGQAbQBhAC4AYwA=
x-cr-puzzleid: {B209E57F-2807-422B-932B-7804649460AC}
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To remove warning messages about 'EXPORT_SYMBOL_GPL', include export header.

drivers/net/ethernet/ti/davinci_cpdma.c:280: warning: data definition has no type or storage class
drivers/net/ethernet/ti/davinci_cpdma.c:280: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
drivers/net/ethernet/ti/davinci_cpdma.c:280: warning: parameter names (without types) in function declaration
drivers/net/ethernet/ti/davinci_cpdma.c:326: warning: data definition has no type or storage class
drivers/net/ethernet/ti/davinci_cpdma.c:326: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
drivers/net/ethernet/ti/davinci_cpdma.c:326: warning: parameter names (without types) in function declaration
drivers/net/ethernet/ti/davinci_cpdma.c:357: warning: data definition has no type or storage class
drivers/net/ethernet/ti/davinci_cpdma.c:357: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
drivers/net/ethernet/ti/davinci_cpdma.c:357: warning: parameter names (without types) in function declaration
drivers/net/ethernet/ti/davinci_cpdma.c:428: warning: data definition has no type or storage class
drivers/net/ethernet/ti/davinci_cpdma.c:428: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
drivers/net/ethernet/ti/davinci_cpdma.c:428: warning: parameter names (without types) in function declaration
drivers/net/ethernet/ti/davinci_cpdma.c:452: warning: data definition has no type or storage class
drivers/net/ethernet/ti/davinci_cpdma.c:452: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
drivers/net/ethernet/ti/davinci_cpdma.c:452: warning: parameter names (without types) in function declaration
drivers/net/ethernet/ti/davinci_cpdma.c:537: warning: data definition has no type or storage class
drivers/net/ethernet/ti/davinci_cpdma.c:537: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
drivers/net/ethernet/ti/davinci_cpdma.c:537: warning: parameter names (without types) in function declaration
drivers/net/ethernet/ti/davinci_cpdma.c:555: warning: data definition has no type or storage class
drivers/net/ethernet/ti/davinci_cpdma.c:555: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
drivers/net/ethernet/ti/davinci_cpdma.c:555: warning: parameter names (without types) in function declaration
drivers/net/ethernet/ti/davinci_cpdma.c:704: warning: data definition has no type or storage class
drivers/net/ethernet/ti/davinci_cpdma.c:704: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
drivers/net/ethernet/ti/davinci_cpdma.c:704: warning: parameter names (without types) in function declaration
drivers/net/ethernet/ti/davinci_cpdma.c:788: warning: data definition has no type or storage class
drivers/net/ethernet/ti/davinci_cpdma.c:788: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
drivers/net/ethernet/ti/davinci_cpdma.c:788: warning: parameter names (without types) in function declaration
drivers/net/ethernet/ti/davinci_cpdma.c:816: warning: data definition has no type or storage class
drivers/net/ethernet/ti/davinci_cpdma.c:816: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
drivers/net/ethernet/ti/davinci_cpdma.c:816: warning: parameter names (without types) in function declaration
drivers/net/ethernet/ti/davinci_cpdma.c:877: warning: data definition has no type or storage class
drivers/net/ethernet/ti/davinci_cpdma.c:877: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
drivers/net/ethernet/ti/davinci_cpdma.c:877: warning: parameter names (without types) in function declaration

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/net/ethernet/ti/davinci_cpdma.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/ethernet/ti/davinci_cpdma.c b/drivers/net/ethernet/ti/davinci_cpdma.c
index d614c37..3c1e423 100644
--- a/drivers/net/ethernet/ti/davinci_cpdma.c
+++ b/drivers/net/ethernet/ti/davinci_cpdma.c
@@ -19,6 +19,7 @@
 #include <linux/err.h>
 #include <linux/dma-mapping.h>
 #include <linux/io.h>
+#include <linux/export.h>
 
 #include "davinci_cpdma.h"
 
-- 
1.7.2.5

Best Regards,
Milo



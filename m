Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755724Ab2EHSYd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 14:24:33 -0400
Received: from mga01.intel.com ([192.55.52.88]:24477 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755968Ab2EHSYD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 14:24:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="150637252"
From: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Sam Ravnborg <sam@ravnborg.org>,
        Joseph Cihula <joseph.cihula@intel.com>,
        Shane Wang <shane.wang@intel.com>, hpa@linux.intel.com,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Subject: [PATCH 22/23] x86, realmode: fixes compilation issue in tboot.c
Date: Tue,  8 May 2012 21:22:45 +0300
Message-Id: <1336501366-28617-23-git-send-email-jarkko.sakkinen@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1336501366-28617-1-git-send-email-jarkko.sakkinen@intel.com>
References: <1336501366-28617-1-git-send-email-jarkko.sakkinen@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed include path of wakeup.h in tboot.c.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
---
 arch/x86/kernel/tboot.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/tboot.c b/arch/x86/kernel/tboot.c
index 65adda4..f84fe00 100644
--- a/arch/x86/kernel/tboot.c
+++ b/arch/x86/kernel/tboot.c
@@ -44,7 +44,7 @@
 #include <asm/e820.h>
 #include <asm/io.h>
 
-#include "acpi/realmode/wakeup.h"
+#include "../realmode/rm/wakeup.h"
 
 /* Global pointer to shared data; NULL means no measured launch. */
 struct tboot *tboot __read_mostly;
-- 
1.7.9.5


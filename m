Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756026Ab1I3Cfk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 22:35:40 -0400
Received: from mga03.intel.com ([143.182.124.21]:7217 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739Ab1I3Cfi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 22:35:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,464,1312182000"; 
   d="scan'208";a="57199333"
From: Lu Guanqun <guanqun.lu@intel.com>
To: gregkh@suse.de, sfr@canb.auug.org.au
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        alan@linux.intel.com, vinod.koul@intel.com, fengguang.wu@intel.com,
        devel@driverdev.osuosl.org, paul.gortmaker@windriver.com,
        Lu Guanqun <guanqun.lu@intel.com>
Subject: [PATCH] intel_sst: fix compile error
Date: Fri, 30 Sep 2011 10:35:35 +0800
Message-Id: <1317350135-15055-1-git-send-email-guanqun.lu@intel.com>
X-Mailer: git-send-email 1.7.6.2
In-Reply-To: <20110930112337.02e0ba383ffd12b6d5d24f39@canb.auug.org.au>
References: <20110930112337.02e0ba383ffd12b6d5d24f39@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

include module.h to fix the following compile errors:

drivers/staging/intel_sst/intelmid.c:52: error: expected declaration specifiers or '...' before string constant
drivers/staging/intel_sst/intelmid.c:52: warning: data definition has no type or storage class
drivers/staging/intel_sst/intelmid.c:52: warning: type defaults to 'int' in declaration of 'MODULE_AUTHOR'
drivers/staging/intel_sst/intelmid.c:52: warning: function declaration isn't a prototype
drivers/staging/intel_sst/intelmid.c:53: error: expected declaration specifiers or '...' before string constant
drivers/staging/intel_sst/intelmid.c:53: warning: data definition has no type or storage class
drivers/staging/intel_sst/intelmid.c:53: warning: type defaults to 'int' in declaration of 'MODULE_AUTHOR'
drivers/staging/intel_sst/intelmid.c:53: warning: function declaration isn't a prototype
drivers/staging/intel_sst/intelmid.c:54: error: expected declaration specifiers or '...' before string constant
drivers/staging/intel_sst/intelmid.c:54: warning: data definition has no type or storage class
drivers/staging/intel_sst/intelmid.c:54: warning: type defaults to 'int' in declaration of 'MODULE_AUTHOR'
drivers/staging/intel_sst/intelmid.c:54: warning: function declaration isn't a prototype
drivers/staging/intel_sst/intelmid.c:55: error: expected declaration specifiers or '...' before string constant
drivers/staging/intel_sst/intelmid.c:55: warning: data definition has no type or storage class
drivers/staging/intel_sst/intelmid.c:55: warning: type defaults to 'int' in declaration of 'MODULE_AUTHOR'
drivers/staging/intel_sst/intelmid.c:55: warning: function declaration isn't a prototype
drivers/staging/intel_sst/intelmid.c:56: error: expected declaration specifiers or '...' before string constant
drivers/staging/intel_sst/intelmid.c:56: warning: data definition has no type or storage class
drivers/staging/intel_sst/intelmid.c:56: warning: type defaults to 'int' in declaration of 'MODULE_DESCRIPTION'
drivers/staging/intel_sst/intelmid.c:56: warning: function declaration isn't a prototype
drivers/staging/intel_sst/intelmid.c:57: error: expected declaration specifiers or '...' before string constant
drivers/staging/intel_sst/intelmid.c:57: warning: data definition has no type or storage class
drivers/staging/intel_sst/intelmid.c:57: warning: type defaults to 'int' in declaration of 'MODULE_LICENSE'
drivers/staging/intel_sst/intelmid.c:57: warning: function declaration isn't a prototype
drivers/staging/intel_sst/intelmid.c:58: error: expected declaration specifiers or '...' before string constant
drivers/staging/intel_sst/intelmid.c:58: warning: data definition has no type or storage class
drivers/staging/intel_sst/intelmid.c:58: warning: type defaults to 'int' in declaration of 'MODULE_SUPPORTED_DEVICE'
drivers/staging/intel_sst/intelmid.c:58: warning: function declaration isn't a prototype
drivers/staging/intel_sst/intelmid.c:64: error: expected ')' before 'int'
drivers/staging/intel_sst/intelmid.c:65: error: expected ')' before string constant
drivers/staging/intel_sst/intelmid.c:66: error: expected ')' before numeric constant
drivers/staging/intel_sst/intelmid.c:67: error: expected ')' before string constant
drivers/staging/intel_sst/intelmid.c:461: warning: data definition has no type or storage class
drivers/staging/intel_sst/intelmid.c:461: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
drivers/staging/intel_sst/intelmid.c:461: warning: parameter names (without types) in function declaration
drivers/staging/intel_sst/intelmid.c:475: warning: data definition has no type or storage class
drivers/staging/intel_sst/intelmid.c:475: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
drivers/staging/intel_sst/intelmid.c:475: warning: parameter names (without types) in function declaration
drivers/staging/intel_sst/intelmid.c: In function 'snd_intelmad_probe':
drivers/staging/intel_sst/intelmid.c:859: error: 'THIS_MODULE' undeclared (first use in this function)
drivers/staging/intel_sst/intelmid.c:859: error: (Each undeclared identifier is reported only once
drivers/staging/intel_sst/intelmid.c:859: error: for each function it appears in.)
drivers/staging/intel_sst/intelmid.c: At top level:
drivers/staging/intel_sst/intelmid.c:989: error: 'THIS_MODULE' undeclared here (not in a function)

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Lu Guanqun <guanqun.lu@intel.com>
---
 drivers/staging/intel_sst/intelmid.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/intel_sst/intelmid.c b/drivers/staging/intel_sst/intelmid.c
index 25656ad..492b660 100644
--- a/drivers/staging/intel_sst/intelmid.c
+++ b/drivers/staging/intel_sst/intelmid.c
@@ -27,6 +27,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/io.h>
 #include <linux/platform_device.h>
-- 
1.7.6.2


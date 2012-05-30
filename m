Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891Ab2E3G0F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 02:26:05 -0400
Received: from mga03.intel.com ([143.182.124.21]:60620 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752031Ab2E3G0D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 02:26:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="149336215"
From: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
To: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH] x86, realmode: ia64 build fix (drivers/acpi/sleep.c)
Date: Wed, 30 May 2012 09:26:02 +0300
Message-Id: <1338359162-5785-1-git-send-email-jarkko.sakkinen@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jarkko Sakkinen <Jarkko Sakkinen jarkko.sakkinen@intel.com>

Added CONFIG_ACPI_SLEEP caging for #include <asm/realmode.h>.

Signed-off-by: Jarkko Sakkinen <Jarkko Sakkinen jarkko.sakkinen@intel.com>
---
 drivers/acpi/sleep.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
index a82fbf6..5b99f64 100644
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -25,7 +25,9 @@
 #include <acpi/acpi_bus.h>
 #include <acpi/acpi_drivers.h>
 
+#ifdef CONFIG_ACPI_SLEEP
 #include <asm/realmode.h>
+#endif
 
 #include "internal.h"
 #include "sleep.h"
-- 
1.7.9.5


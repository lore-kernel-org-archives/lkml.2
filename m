Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932387Ab2EIVEH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 17:04:07 -0400
Received: from mga02.intel.com ([134.134.136.20]:36767 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758661Ab2EIVEF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 17:04:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="138805987"
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: lenb@kernel.org
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, len.brown@intel.com,
        linux-acpi@vger.kernel.org, "H. Peter Anvin" <hpa@linux.intel.com>,
        Matthew Garrett <mjg@redhat.com>
Subject: [PATCH] acpi, bgrd: Add missing <linux/io.h> to drivers/acpi/bgrt.c
Date: Wed,  9 May 2012 14:04:02 -0700
Message-Id: <1336597442-9399-1-git-send-email-hpa@linux.intel.com>
X-Mailer: git-send-email 1.7.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@linux.intel.com>

The ACPI BGRT driver uses ioremap() and memcpy_fromio(), which means
it needs to #include <linux/io.h>.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Matthew Garrett <mjg@redhat.com>
---
 drivers/acpi/bgrt.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/bgrt.c b/drivers/acpi/bgrt.c
index 8cf6c46..6680df3 100644
--- a/drivers/acpi/bgrt.c
+++ b/drivers/acpi/bgrt.c
@@ -11,6 +11,7 @@
 #include <linux/init.h>
 #include <linux/device.h>
 #include <linux/sysfs.h>
+#include <linux/io.h>
 #include <acpi/acpi.h>
 #include <acpi/acpi_bus.h>
 
-- 
1.7.6.4


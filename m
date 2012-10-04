Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024Ab2JDJCu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 05:02:50 -0400
Received: from mail.x86-64.org ([217.9.48.20]:37580 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750698Ab2JDJCs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 05:02:48 -0400
From: Borislav Petkov <bp@amd64.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Borislav Petkov <borislav.petkov@amd.com>,
        Thomas Renninger <trenn@suse.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-acpi@vger.kernel.org
Subject: [PATCH] ACPI: Sanitize ACPI_INITRD_TABLE_OVERRIDE Kconfig text
Date: Thu,  4 Oct 2012 11:02:34 +0200
Message-Id: <1349341354-21466-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.11.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Make the bool prompt text shorter and fit the style of Kconfig options
and move the actual description into the help text.

No functionality change.

Cc: Thomas Renninger <trenn@suse.de>
Cc: H. Peter Anvin <hpa@linux.intel.com>
Cc: linux-acpi@vger.kernel.org
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---

I guess this one is against tip's x86/acpi branch.

 drivers/acpi/Kconfig | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 44cea5d4b04e..c556b794e12f 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -262,13 +262,13 @@ config ACPI_CUSTOM_DSDT
 	default ACPI_CUSTOM_DSDT_FILE != ""
 
 config ACPI_INITRD_TABLE_OVERRIDE
-	bool "ACPI tables can be passed via uncompressed cpio in initrd"
+	bool "ACPI tables override via initrd"
 	default n
 	help
 	  This option provides functionality to override arbitrary ACPI tables
-	  via initrd. No functional change if no ACPI tables are passed via
-	  initrd, therefore it's safe to say Y.
-	  See Documentation/acpi/initrd_table_override.txt for details
+	  via uncompressed cpio in initrd. No functional change if no ACPI
+	  tables are passed via the initrd, therefore it's safe to say Y.
+	  See Documentation/acpi/initrd_table_override.txt for details.
 
 config ACPI_BLACKLIST_YEAR
 	int "Disable ACPI for systems before Jan 1st this year" if X86_32
-- 
1.7.11.rc1


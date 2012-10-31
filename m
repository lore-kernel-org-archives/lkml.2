Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422973Ab2JaOfy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 10:35:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52850 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422957Ab2JaOfw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 10:35:52 -0400
From: Thomas Renninger <trenn@suse.de>
To: hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, Thomas Renninger <trenn@suse.de>
Subject: [PATCH 3/3] ACPI: Overriding ACPI tables via initrd only works with an initrd
Date: Wed, 31 Oct 2012 15:35:47 +0100
Message-Id: <1351694147-10904-4-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1351694147-10904-1-git-send-email-trenn@suse.de>
References: <1351694147-10904-1-git-send-email-trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reflect this dependency in Kconfig.
Shorten the config description as suggested by Borislav Petkov

Signed-off-by: Thomas Renninger <trenn@suse.de>
---
 drivers/acpi/Kconfig |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 44cea5d..ca939b4 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -262,7 +262,8 @@ config ACPI_CUSTOM_DSDT
 	default ACPI_CUSTOM_DSDT_FILE != ""
 
 config ACPI_INITRD_TABLE_OVERRIDE
-	bool "ACPI tables can be passed via uncompressed cpio in initrd"
+	bool "ACPI tables override via initrd"
+	depends on BLK_DEV_INITRD
 	default n
 	help
 	  This option provides functionality to override arbitrary ACPI tables
-- 
1.7.6.1


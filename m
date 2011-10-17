Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512Ab1JQKki (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 06:40:38 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:42754 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755324Ab1JQKkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 06:40:36 -0400
From: Matt Fleming <matt@console-pimps.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>, Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Matt Fleming <matt.fleming@linux.intel.com>
Subject: [PATCH 08/10] efi.h: Add boottime->locate_handle search types
Date: Mon, 17 Oct 2011 11:40:15 +0100
Message-Id: <1318848017-12301-9-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1318848017-12301-1-git-send-email-matt@console-pimps.org>
References: <1318848017-12301-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@linux.intel.com>

The x86 EFI boot stub needs to locate handles for various protocols.

Cc: Matthew Garrett <mjg@redhat.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>
Signed-off-by: Matt Fleming <matt.fleming@linux.intel.com>
---
 include/linux/efi.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/include/linux/efi.h b/include/linux/efi.h
index e46d771..d407c88 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -472,6 +472,13 @@ extern int __init efi_setup_pcdp_console(char *);
 #define EFI_VARIABLE_RUNTIME_ACCESS     0x0000000000000004
 
 /*
+ * The type of search to perform when calling boottime->locate_handle
+ */
+#define EFI_LOCATE_ALL_HANDLES			0
+#define EFI_LOCATE_BY_REGISTER_NOTIFY		1
+#define EFI_LOCATE_BY_PROTOCOL			2
+
+/*
  * EFI Device Path information
  */
 #define EFI_DEV_HW			0x01
-- 
1.7.4.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256Ab1HKLBN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 07:01:13 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:53864 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753458Ab1HKK77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 06:59:59 -0400
From: Matt Fleming <matt@console-pimps.org>
To: linux-kernel@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>, "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH 6/9] efi.h: Add boottime->locate_handle search types
Date: Thu, 11 Aug 2011 11:59:43 +0100
Message-Id: <1313060386-4858-7-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1313060386-4858-1-git-send-email-matt@console-pimps.org>
References: <1313060386-4858-1-git-send-email-matt@console-pimps.org>
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
index 379efe8..d06e0ae 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -466,6 +466,13 @@ extern int __init efi_setup_pcdp_console(char *);
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


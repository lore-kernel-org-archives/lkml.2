Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757576Ab1ILOgK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 10:36:10 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:54438 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757231Ab1ILOfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 10:35:07 -0400
From: Matt Fleming <matt@console-pimps.org>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, Matthew Garrett <mjg@redhat.com>,
        x86@kernel.org, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Matt Fleming <matt.fleming@intel.com>
Subject: [PATCH v2 07/10] efi.h: Add graphics protocol guids
Date: Mon, 12 Sep 2011 15:34:51 +0100
Message-Id: <1315838094-2307-8-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1315838094-2307-1-git-send-email-matt@console-pimps.org>
References: <1315838094-2307-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

The x86 EFI boot stub uses the Graphics Output Protocol and Universal
Graphics Adapter (UGA) protocol guids when initialising graphics
during boot.

Cc: Matthew Garrett <mjg@redhat.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---

v2: Added UGA and PCI I/O guids.

 include/linux/efi.h |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/include/linux/efi.h b/include/linux/efi.h
index 378f2cd..e46d771 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -298,6 +298,15 @@ typedef efi_status_t efi_query_capsule_caps_t(efi_capsule_header_t **capsules,
 #define LOADED_IMAGE_PROTOCOL_GUID \
     EFI_GUID(  0x5b1b31a1, 0x9562, 0x11d2, 0x8e, 0x3f, 0x00, 0xa0, 0xc9, 0x69, 0x72, 0x3b )
 
+#define EFI_GRAPHICS_OUTPUT_PROTOCOL_GUID \
+    EFI_GUID(  0x9042a9de, 0x23dc, 0x4a38, 0x96, 0xfb, 0x7a, 0xde, 0xd0, 0x80, 0x51, 0x6a )
+
+#define EFI_UGA_PROTOCOL_GUID \
+    EFI_GUID(  0x982c298b, 0xf4fa, 0x41cb, 0xb8, 0x38, 0x77, 0xaa, 0x68, 0x8f, 0xb8, 0x39 )
+
+#define EFI_PCI_IO_PROTOCOL_GUID \
+    EFI_GUID(  0x4cf5b200, 0x68b8, 0x4ca5, 0x9e, 0xec, 0xb2, 0x3e, 0x3f, 0x50, 0x2, 0x9a )
+
 typedef struct {
 	efi_guid_t guid;
 	unsigned long table;
-- 
1.7.4.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821Ab1HKLAF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 07:00:05 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:53860 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753944Ab1HKK76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 06:59:58 -0400
From: Matt Fleming <matt@console-pimps.org>
To: linux-kernel@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>, "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH 5/9] efi.h: Add graphics protocol guid
Date: Thu, 11 Aug 2011 11:59:42 +0100
Message-Id: <1313060386-4858-6-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1313060386-4858-1-git-send-email-matt@console-pimps.org>
References: <1313060386-4858-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@linux.intel.com>

The x86 EFI boot stub uses this guid when initialising graphics during
boot.

Cc: Matthew Garrett <mjg@redhat.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>
Signed-off-by: Matt Fleming <matt.fleming@linux.intel.com>
---
 include/linux/efi.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/linux/efi.h b/include/linux/efi.h
index cd28c7a..379efe8 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -298,6 +298,9 @@ typedef efi_status_t efi_query_capsule_caps_t(efi_capsule_header_t **capsules,
 #define LOADED_IMAGE_PROTOCOL_GUID \
     EFI_GUID(  0x5b1b31a1, 0x9562, 0x11d2, 0x8e, 0x3f, 0x00, 0xa0, 0xc9, 0x69, 0x72, 0x3b )
 
+#define EFI_GRAPHICS_OUTPUT_PROTOCOL_GUID \
+    EFI_GUID(  0x9042a9de, 0x23dc, 0x4a38, 0x96, 0xfb, 0x7a, 0xde, 0xd0, 0x80, 0x51, 0x6a )
+
 typedef struct {
 	efi_guid_t guid;
 	unsigned long table;
-- 
1.7.4.4


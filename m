Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259Ab1LJCld (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 21:41:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48829 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130Ab1LJCl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 21:41:28 -0500
Date: Fri, 9 Dec 2011 18:41:18 -0800
From: tip-bot for Matt Fleming <matt.fleming@intel.com>
Message-ID: <tip-0f7c5d477f2ce552997831d80e2c872cca1b9054@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, mjg@redhat.com, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, hpa@linux.intel.com,
        matt.fleming@intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, mjg@redhat.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        matt.fleming@intel.com, hpa@linux.intel.com
In-Reply-To: <1318848017-12301-1-git-send-email-matt@console-pimps.org>
References: <1318848017-12301-1-git-send-email-matt@console-pimps.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/efi] efi.h: Add graphics protocol guids
Git-Commit-ID: 0f7c5d477f2ce552997831d80e2c872cca1b9054
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 09 Dec 2011 18:41:23 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0f7c5d477f2ce552997831d80e2c872cca1b9054
Gitweb:     http://git.kernel.org/tip/0f7c5d477f2ce552997831d80e2c872cca1b9054
Author:     Matt Fleming <matt.fleming@intel.com>
AuthorDate: Tue, 15 Nov 2011 12:57:16 +0000
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 9 Dec 2011 17:35:46 -0800

efi.h: Add graphics protocol guids

The x86 EFI boot stub uses the Graphics Output Protocol and Universal
Graphics Adapter (UGA) protocol guids when initialising graphics
during boot.

Cc: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Link: http://lkml.kernel.org/r/1318848017-12301-1-git-send-email-matt@console-pimps.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
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

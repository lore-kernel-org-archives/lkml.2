Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231Ab1LJCmS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 21:42:18 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48838 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130Ab1LJCmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 21:42:14 -0500
Date: Fri, 9 Dec 2011 18:42:04 -0800
From: tip-bot for Matt Fleming <matt.fleming@intel.com>
Message-ID: <tip-e2527a7cbec073b69a251193f200a88efbced7ad@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, mjg@redhat.com, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, hpa@linux.intel.com,
        matt.fleming@intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, mjg@redhat.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        matt.fleming@intel.com, hpa@linux.intel.com
In-Reply-To: <1318848017-12301-1-git-send-email-matt@console-pimps.org>
References: <1318848017-12301-1-git-send-email-matt@console-pimps.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/efi] efi.h: Add boottime->locate_handle search types
Git-Commit-ID: e2527a7cbec073b69a251193f200a88efbced7ad
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 09 Dec 2011 18:42:10 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e2527a7cbec073b69a251193f200a88efbced7ad
Gitweb:     http://git.kernel.org/tip/e2527a7cbec073b69a251193f200a88efbced7ad
Author:     Matt Fleming <matt.fleming@intel.com>
AuthorDate: Tue, 15 Nov 2011 12:57:26 +0000
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 9 Dec 2011 17:35:49 -0800

efi.h: Add boottime->locate_handle search types

The x86 EFI boot stub needs to locate handles for various protocols.

Cc: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Link: http://lkml.kernel.org/r/1318848017-12301-1-git-send-email-matt@console-pimps.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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

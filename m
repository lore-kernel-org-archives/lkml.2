Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142Ab1LRXwi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 18:52:38 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38764 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990Ab1LRXwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 18:52:37 -0500
Date: Sun, 18 Dec 2011 15:52:19 -0800
From: tip-bot for Alan Cox <alan@linux.intel.com>
Message-ID: <tip-c95aaeffd8a41bde48270040abe3cab8ea328787@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, alan@linux.intel.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20111217174215.7096.7786.stgit@bob.linux.org.uk>
References: <20111217174215.7096.7786.stgit@bob.linux.org.uk>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86/intel/scu/ipc:
  Match the changes in the x86 configuration
Git-Commit-ID: c95aaeffd8a41bde48270040abe3cab8ea328787
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 18 Dec 2011 15:52:25 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c95aaeffd8a41bde48270040abe3cab8ea328787
Gitweb:     http://git.kernel.org/tip/c95aaeffd8a41bde48270040abe3cab8ea328787
Author:     Alan Cox <alan@linux.intel.com>
AuthorDate: Sat, 17 Dec 2011 17:42:27 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 18 Dec 2011 09:16:07 +0100

x86/intel/scu/ipc: Match the changes in the x86 configuration

We need to depend on INTEL_MID because the SCU is Moorestown and
Medfield.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: mjg@redhat.com
Link: http://lkml.kernel.org/r/20111217174215.7096.7786.stgit@bob.linux.org.uk
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/platform/x86/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 7f43cf8..f995e6e 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -639,7 +639,7 @@ config ACPI_CMPC
 
 config INTEL_SCU_IPC
 	bool "Intel SCU IPC Support"
-	depends on X86_MRST
+	depends on X86_INTEL_MID
 	default y
 	---help---
 	  IPC is used to bridge the communications between kernel and SCU on

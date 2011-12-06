Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933415Ab1LFOSd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 09:18:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36506 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933255Ab1LFOSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 09:18:32 -0500
Date: Tue, 6 Dec 2011 06:17:54 -0800
From: tip-bot for Alan Cox <alan@linux.intel.com>
Message-ID: <tip-4e2b1c4f56227c742bbd2ea8e8f559567eb80c3f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, alan@linux.intel.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20111206132811.4041.32549.stgit@bob.linux.org.uk>
References: <20111206132811.4041.32549.stgit@bob.linux.org.uk>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/intel_mid: Kconfig select fix
Git-Commit-ID: 4e2b1c4f56227c742bbd2ea8e8f559567eb80c3f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 06 Dec 2011 06:18:03 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4e2b1c4f56227c742bbd2ea8e8f559567eb80c3f
Gitweb:     http://git.kernel.org/tip/4e2b1c4f56227c742bbd2ea8e8f559567eb80c3f
Author:     Alan Cox <alan@linux.intel.com>
AuthorDate: Tue, 6 Dec 2011 13:28:22 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 6 Dec 2011 14:40:50 +0100

x86/intel_mid: Kconfig select fix

If we select a symbol it should have a type declared first
otherwise in some situations the config tools get upset. They
are currently perhaps a bit too resilient which is why this
wasn't noticed initially.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Link: http://lkml.kernel.org/r/20111206132811.4041.32549.stgit@bob.linux.org.uk
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Kconfig |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 5553f9f..efb4294 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -401,6 +401,9 @@ config X86_WANT_INTEL_MID
 
 if X86_WANT_INTEL_MID
 
+config X86_INTEL_MID
+	bool
+
 config X86_MRST
        bool "Moorestown MID platform"
 	depends on PCI

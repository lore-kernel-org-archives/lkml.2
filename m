Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846Ab1FRU4a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 16:56:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:44556 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752293Ab1FRU40 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 16:56:26 -0400
Date: Sat, 18 Jun 2011 20:55:52 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Message-ID: <tip-8hs7yob6wib4vblmrmbpbav4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tony.luck@intel.com, bp@amd64.org, tglx@linutronix.de,
        hpa@linux.intel.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, tony.luck@intel.com, hpa@linux.intel.com,
        bp@amd64.org, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, MAINTAINERS: Add x86 MCE people
Git-Commit-ID: c1f5c54b57341e872a9d375dccef7257f86033ef
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 18 Jun 2011 20:55:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c1f5c54b57341e872a9d375dccef7257f86033ef
Gitweb:     http://git.kernel.org/tip/c1f5c54b57341e872a9d375dccef7257f86033ef
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Sat, 18 Jun 2011 22:51:13 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 18 Jun 2011 22:51:13 +0200

x86, MAINTAINERS: Add x86 MCE people

Announce the new x86 MCE infrastructure maintainers.

Acked-by: Borislav Petkov <bp@amd64.org>
Acked-by: Tony Luck <tony.luck@intel.com>
Acked-by: H. Peter Anvin <hpa@linux.intel.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/n/tip-8hs7yob6wib4vblmrmbpbav4@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 MAINTAINERS |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 502f2dd..b12b8c1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7007,6 +7007,13 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mjg59/platform-drivers-x86.
 S:	Maintained
 F:	drivers/platform/x86
 
+X86 MCE INFRASTRUCTURE
+M:	Tony Luck <tony.luck@intel.com>
+M:	Borislav Petkov <bp@amd64.org>
+L:	linux-edac@vger.kernel.org
+S:	Maintained
+F:	arch/x86/kernel/cpu/mcheck/*
+
 XEN HYPERVISOR INTERFACE
 M:	Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
 M:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

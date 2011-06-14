Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923Ab1FNQJU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 12:09:20 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:57647 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab1FNQJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 12:09:19 -0400
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@amd64.org>,
        Tony Luck <tony.luck@intel.com>
Subject: [PATCH] MAINTAINERS: Add x86 RAS people
Date: Tue, 14 Jun 2011 18:08:54 +0200
Message-Id: <1308067734-6156-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Announce the new RAS infrastructure maintainers. The file patterns below
will change after we start the restructuring.

Signed-off-by: Borislav Petkov <bp@amd64.org>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 MAINTAINERS |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 29801f7..901ed1c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6997,6 +6997,13 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mjg59/platform-drivers-x86.
 S:	Maintained
 F:	drivers/platform/x86
 
+X86 RAS INFRASTRUCTURE
+M:	Tony Luck <tony.luck@intel.com>
+M:	Borislav Petkov <bp@amd64.org>
+L:	linux-edac@vger.kernel.org
+S:	Maintained
+F:	arch/x86/kernel/cpu/mcheck/*
+
 XEN HYPERVISOR INTERFACE
 M:	Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
 M:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
-- 
1.7.4.rc2


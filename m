Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965208Ab0HFXDJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 19:03:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:55025 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935893Ab0HFXCw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 19:02:52 -0400
Date: Fri, 6 Aug 2010 23:02:22 GMT
Message-Id: <201008062302.o76N2M1Z016627@hera.kernel.org>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86/apic for 2.6.36
Cc: Cyrill Gorcunov <gorcunov@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Javier Martinez Canillas <martinez.javier@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rakib Mullick <rakib.mullick@gmail.com>, Tejun Heo <tj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 06 Aug 2010 23:02:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit fc1caf6eafb30ea185720e29f7f5eccca61ecd60:

  Merge branch 'drm-core-next' of git://git.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6 (2010-08-05 16:02:01 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-apic-for-linus

Javier Martinez Canillas (1):
      x86/apic/es7000_32: Remove unused variable

 arch/x86/kernel/apic/es7000_32.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic/es7000_32.c b/arch/x86/kernel/apic/es7000_32.c
index 425e53a..8593582 100644
--- a/arch/x86/kernel/apic/es7000_32.c
+++ b/arch/x86/kernel/apic/es7000_32.c
@@ -129,7 +129,6 @@ int					es7000_plat;
  * GSI override for ES7000 platforms.
  */
 
-static unsigned int			base;
 
 static int __cpuinit wakeup_secondary_cpu_via_mip(int cpu, unsigned long eip)
 {

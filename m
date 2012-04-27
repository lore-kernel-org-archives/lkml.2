Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858Ab2D0G5Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 02:57:24 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:36298 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756353Ab2D0G5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 02:57:23 -0400
Date: Fri, 27 Apr 2012 08:57:18 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes
Message-ID: <20120427065718.GA30845@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus

   HEAD: ea0dcf903e7d76aa5d483d876215fedcfdfe140f x86/apic: Use x2apic physical mode based on FADT setting

Thanks,

	Ingo

------------------>
Greg Pearson (1):
      x86/apic: Use x2apic physical mode based on FADT setting

H Hartley Sweeten (1):
      x86/mrst: Quiet sparse noise about plain integer as NULL pointer

Ingo Molnar (1):
      Merge tag 'l3-fix-for-3.5' of git://git.kernel.org/.../bp/bp into x86/urgent

Srivatsa S. Bhat (1):
      x86, intel_cacheinfo: Fix error return code in amd_set_l3_disable_slot()


 arch/x86/kernel/apic/x2apic_phys.c    |    6 ++++++
 arch/x86/kernel/cpu/intel_cacheinfo.c |    8 ++++----
 arch/x86/platform/mrst/mrst.c         |    4 ++--
 3 files changed, 12 insertions(+), 6 deletions(-)

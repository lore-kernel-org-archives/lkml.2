Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708Ab1FPHRx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:17:53 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:35457 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754144Ab1FPHRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:17:48 -0400
Date: Thu, 16 Jun 2011 09:17:26 +0200
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>,
        edac-devel <linux-edac@vger.kernel.org>
Subject: [GIT PULL] RAS: x86 mce cleanup
Message-ID: <20110616071726.GA21197@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

here's the first pull request from Tony and me. Hopefully not the last.

The good thing is, with our different timezones you get 24/7 RAS support :-).

Thanks.

The following changes since commit 3a2289a4a317e0290a8bc7af28c62c9830cb12e5:

  Merge branch 'for-linus-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu (2011-06-14 11:28:54 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git for-tip-mce

Hidetoshi Seto (11):
      x86, mce, severity: Make formatting a bit more readable
      x86, mce, severity: Cleanup severity table
      x86, mce, severity: Trivial cleanups
      x86, mce: Replace MCE_SELF_VECTOR by irq_work
      x86, mce: Replace MCM_ with MCI_MISC_
      x86, mce: Introduce mce_gather_info()
      x86, mce: Check the result of ancient_init()
      x86, mce: Cleanup mce_create/remove_device
      x86, mce: Cleanup mce_read()
      x86, mce: Use prefix mce_chrdev_ to group functions
      x86, mce: Use prefix mce_sysdev_ to group functions

Tony Luck (1):
      x86, mce, severity: Fix two severities table signatures

 arch/x86/include/asm/entry_arch.h         |    4 -
 arch/x86/include/asm/hw_irq.h             |    1 -
 arch/x86/include/asm/irq_vectors.h        |    5 -
 arch/x86/include/asm/mce.h                |   19 ++-
 arch/x86/kernel/cpu/mcheck/mce-severity.c |  152 ++++++++++------
 arch/x86/kernel/cpu/mcheck/mce.c          |  288 ++++++++++++++---------------
 arch/x86/kernel/cpu/mcheck/mce_amd.c      |   10 +-
 arch/x86/kernel/entry_64.S                |    5 -
 arch/x86/kernel/irqinit.c                 |    3 -
 9 files changed, 251 insertions(+), 236 deletions(-)

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751273Ab1ESEHA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 00:07:00 -0400
Received: from gate.crashing.org ([63.228.1.57]:58743 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896Ab1ESEG7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 00:06:59 -0400
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 May 2011 14:06:18 +1000
Message-ID: <1305777978.7481.37.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus

Dunno if it's too late or not yet but here's 3 fixes for powerpc that
would be welcome to have in before the release. If not I'll send them
first thing next (one of them is already in -next in fact).

Those are regression fixes and a build breakage.

Cheers,
Ben.

The following changes since commit fce519588acfac249e8fdc1f5016c73d617de315:

  Merge branch 'devicetree/merge' of git://git.secretlab.ca/git/linux-2.6 (2011-05-18 13:25:57 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

Ben Hutchings (1):
      powerpc/kexec: Fix build failure on 32-bit SMP

Benjamin Herrenschmidt (1):
      powerpc/smp: Make start_secondary_resume available to all CPU variants

kerstin jonsson (1):
      powerpc/4xx: Fix regression in SMP on 476

 arch/powerpc/kernel/crash.c   |   59 +++++++++++++++++++++--------------------
 arch/powerpc/kernel/head_32.S |    9 ------
 arch/powerpc/kernel/misc_32.S |   11 +++++++
 arch/powerpc/kernel/smp.c     |    4 +-
 4 files changed, 43 insertions(+), 40 deletions(-)



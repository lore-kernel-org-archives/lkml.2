Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644Ab1CIX43 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 18:56:29 -0500
Received: from gate.crashing.org ([63.228.1.57]:40021 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752390Ab1CIX42 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 18:56:28 -0500
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Mar 2011 10:55:45 +1100
Message-ID: <1299714945.22236.444.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here's a pair of regression fixes for 2.6.38. One fixes a 2.6.37
regression (I'll send it to -stable separately) that breaks booting on
legacy iSeries, and the other one disables a newly introduced features
as it triggers nasty races in the scheduler that causes hangs and seem
to be too much to fix for this release (working with PeterZ on it).

Cheers,
Ben.

The following changes since commit a5abba989deceb731047425812d268daf7536575:

  Linux 2.6.38-rc8 (2011-03-07 21:09:37 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

Benjamin Herrenschmidt (2):
      powerpc/iseries: Fix early init access to lppaca
      powerpc/pseries: Disable VPNH feature

 arch/powerpc/include/asm/lppaca.h      |   16 ++++++++++++++++
 arch/powerpc/kernel/paca.c             |   14 --------------
 arch/powerpc/mm/numa.c                 |    3 ++-
 arch/powerpc/platforms/iseries/dt.c    |    6 +++---
 arch/powerpc/platforms/iseries/setup.c |    1 +
 5 files changed, 22 insertions(+), 18 deletions(-)



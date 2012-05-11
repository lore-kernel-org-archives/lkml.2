Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761313Ab2EKXwL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 19:52:11 -0400
Received: from gate.crashing.org ([63.228.1.57]:37261 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761249Ab2EKXwG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 19:52:06 -0400
Message-ID: <1336780315.31450.3.camel@pasglop>
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Sat, 12 May 2012 09:51:55 +1000
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

It looks like my previous fix for the lazy irq masking problem wasn't
quite enough. There was another problem related to performance monitor
interrupts acting as NMIs leaving the flags in an incorrect state.
Here's a fix that finally seems to make perf solid again.

The following changes since commit 4e25651b70b8d6ded7229ead8181619e121b648d:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu (2012-05-11 09:28:35 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

for you to fetch changes up to 7c0482e3d055e5de056d3c693b821e39205b99ae:

  powerpc/irq: Fix another case of lazy IRQ state getting out of sync (2012-05-12 09:40:41 +1000)

----------------------------------------------------------------
Benjamin Herrenschmidt (1):
      powerpc/irq: Fix another case of lazy IRQ state getting out of sync

 arch/powerpc/kernel/entry_64.S |   44 ++++++++++++++++++++++++++++------------
 arch/powerpc/kernel/irq.c      |   13 ++++++++++++
 2 files changed, 44 insertions(+), 13 deletions(-)



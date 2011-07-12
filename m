Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757986Ab1GLB1F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 21:27:05 -0400
Received: from gate.crashing.org ([63.228.1.57]:45483 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751552Ab1GLB1D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 21:27:03 -0400
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Jul 2011 11:26:21 +1000
Message-ID: <1310433981.4968.19.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

I almost forgot to send you these two patches I had around for some time
now. They fix a nasty warning at boot (and possibly more) when booting a
kernel with CONFIG_PPC_PSERIES enabled on a non-pseries machine.

The first patch just moves a duplicate #define to a common header file,
the second patch is the actual fix.

Cheers,
Ben.

The following changes since commit 620917de59eeb934b9f8cf35cc2d95c1ac8ed0fc:

  Linux 3.0-rc7 (2011-07-11 16:51:52 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

Benjamin Herrenschmidt (2):
      mm: Move definition of MIN_MEMORY_BLOCK_SIZE to a header
      powerpc/mm: Fix memory_block_size_bytes() for non-pseries

 arch/powerpc/platforms/pseries/hotplug-memory.c |   30 ++++++++++++++--------
 arch/x86/mm/init_64.c                           |    3 +-
 drivers/base/memory.c                           |    1 -
 include/linux/memory.h                          |    2 +
 4 files changed, 22 insertions(+), 14 deletions(-)
 


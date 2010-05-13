Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758303Ab0EMBqe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 21:46:34 -0400
Received: from gate.crashing.org ([63.228.1.57]:54703 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753506Ab0EMBqc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 21:46:32 -0400
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1273660604.21352.123.camel@pasglop>
References: <1273650396.21352.121.camel@pasglop>
	 <B0104965-09F9-4372-AA9F-F6D0FDEA67F2@kernel.crashing.org>
	 <1273660604.21352.123.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 May 2010 11:46:21 +1000
Message-ID: <1273715181.21352.157.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

I've added to my merge branch Kumar's swiotlb fix. Here's the updated
pull request.

Thanks !

Cheers,
Ben.

The following changes since commit cea0d767c29669bf89f86e4aee46ef462d2ebae8:
  Linus Torvalds (1):
        Merge branch 'hwmon-for-linus' of git://git.kernel.org/.../jdelvare/staging

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

Benjamin Herrenschmidt (1):
      Merge commit 'kumar/merge' into merge

Kumar Gala (1):
      powerpc/swiotlb: Fix off by one in determining boundary of which ops to use

Paul Mackerras (1):
      powerpc/perf_event: Fix oops due to perf_event_do_pending call

 arch/powerpc/include/asm/hw_irq.h |   38 -----------------------
 arch/powerpc/kernel/asm-offsets.c |    1 -
 arch/powerpc/kernel/dma-swiotlb.c |    5 ++-
 arch/powerpc/kernel/entry_64.S    |    9 -----
 arch/powerpc/kernel/irq.c         |    6 ----
 arch/powerpc/kernel/time.c        |   60 +++++++++++++++++++++++++++++-------
 6 files changed, 51 insertions(+), 68 deletions(-)



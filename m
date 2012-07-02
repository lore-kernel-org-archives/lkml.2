Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396Ab2GBE5u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 00:57:50 -0400
Received: from gate.crashing.org ([63.228.1.57]:35130 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752034Ab2GBE5t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 00:57:49 -0400
Message-ID: <1341205059.2588.30.camel@pasglop>
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Mon, 02 Jul 2012 14:57:39 +1000
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus 

Here are two more fixes that I "missed" when scrubbing patchwork last
week which are worth still having in 3.5.

Cheers,
Ben.

The following changes since commit bc6dc752f35488160ffac07ae91bed1bddaea32a:

  powerpc/pseries: Fix software invalidate TCE (2012-06-29 14:35:37 +1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

for you to fetch changes up to 2f584a146a2965b82fce89b8d2f95dc5cfe468d0:

  powerpc/kvm: sldi should be sld (2012-07-02 14:30:12 +1000)

----------------------------------------------------------------
Anton Blanchard (1):
      powerpc/xmon: Use cpumask iterator to avoid warning

Michael Neuling (1):
      powerpc/kvm: sldi should be sld

 arch/powerpc/kvm/book3s_hv_rmhandlers.S |    2 +-
 arch/powerpc/xmon/xmon.c                |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)



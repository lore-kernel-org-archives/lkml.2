Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580Ab2KYWQS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 17:16:18 -0500
Received: from gate.crashing.org ([63.228.1.57]:50194 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753517Ab2KYWQR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 17:16:17 -0500
Message-ID: <1353881770.16666.7.camel@pasglop>
Subject: Re: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Mon, 26 Nov 2012 09:16:10 +1100
In-Reply-To: <1353881283.16666.5.camel@pasglop>
References: <1353881249.16666.4.camel@pasglop>
	 <1353881283.16666.5.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-11-26 at 09:08 +1100, Benjamin Herrenschmidt wrote:
> On Mon, 2012-11-26 at 09:07 +1100, Benjamin Herrenschmidt wrote:
> > Hi Linus !
> > 
> > Here's a patch that would be good to still have in 3.7. It's a one liner fixing
> > a regression introduced by the new EEH code in .37 (potential oops on some
> > PCI setups when configuring MSIs).

I've just added a second fix for EEH (Gavin found another issue) which
is trivial enough (and tested) so it should still go in. Updated pull
request:

The following changes since commit
d6dc24613c222f9057131ccbd5264a10bcba9f97:

  Merge remote-tracking branch 'agust/merge' into merge (2012-11-21
13:24:49 +1100)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

for you to fetch changes up to e716e014384688d1a50d1aa5213ee74748c6d4e0:

  powerpc/eeh: Do not invalidate PE properly (2012-11-26 09:14:16 +1100)

----------------------------------------------------------------
Alexey Kardashevskiy (1):
      powerpc/pseries: Fix oops with MSIs when missing EEH PEs

Gavin Shan (1):
      powerpc/eeh: Do not invalidate PE properly

 arch/powerpc/platforms/pseries/eeh_pe.c |    2 +-
 arch/powerpc/platforms/pseries/msi.c    |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)



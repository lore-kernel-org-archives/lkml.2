Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696Ab2KYXIO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 18:08:14 -0500
Received: from gate.crashing.org ([63.228.1.57]:44247 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753632Ab2KYXIO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 18:08:14 -0500
Message-ID: <1353881283.16666.5.camel@pasglop>
Subject: Re: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Mon, 26 Nov 2012 09:08:03 +1100
In-Reply-To: <1353881249.16666.4.camel@pasglop>
References: <1353881249.16666.4.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-11-26 at 09:07 +1100, Benjamin Herrenschmidt wrote:
> Hi Linus !
> 
> Here's a patch that would be good to still have in 3.7. It's a one liner fixing
> a regression introduced by the new EEH code in .37 (potential oops on some
> PCI setups when configuring MSIs).
> 
> Cheers,
> Ben.
> 
> The following changes since commit d6dc24613c222f9057131ccbd5264a10bcba9f97:
> 
>   Merge remote-tracking branch 'agust/merge' into merge (2012-11-21 13:24:49 +1100)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git 

And the branch is "merge".

Cheers,
Ben.

> 
> for you to fetch changes up to bb4618823a3389086f157fafb2a0d97cade8d89f:
> 
>   powerpc/pseries: Fix oops with MSIs when missing EEH PEs (2012-11-23 13:26:05 +1100)
> 
> ----------------------------------------------------------------
> Alexey Kardashevskiy (1):
>       powerpc/pseries: Fix oops with MSIs when missing EEH PEs
> 
>  arch/powerpc/platforms/pseries/msi.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 



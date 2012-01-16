Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211Ab2APTZa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 14:25:30 -0500
Received: from gate.crashing.org ([63.228.1.57]:38828 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755950Ab2APTZ2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 14:25:28 -0500
Subject: Re: [git pull] Please pull powerpc.git merge branch
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1326435694.23910.229.camel@pasglop>
Date: Mon, 16 Jan 2012 13:21:51 -0600
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <5742F9CB-77C0-40AF-9719-B55AB2C17D8C@kernel.crashing.org>
References: <1326435694.23910.229.camel@pasglop>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
X-Mailer: Apple Mail (2.1251.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 13, 2012, at 12:21 AM, Benjamin Herrenschmidt wrote:

> Hi Linus !
> 
> Please pull this couple of important bug fixes (a commit
> that went in breaks booting on some machines, this fixes
> it properly).
> 
> Thanks !
> 
> Cheers,
> Ben.
> 
> The following changes since commit 7b3480f8b701170c046e1ed362946f5f0d005e13:
> 
>  Merge tag 'for-linus-3.3' of git://git.infradead.org/mtd-2.6 (2012-01-10 13:45:22 -0800)
> 
> are available in the git repository at:
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge
> 
> Anton Blanchard (1):
>      powerpc: Fix RCU idle and hcall tracing
> 
> Li Zhong (1):
>      powerpc: Fix unpaired __trace_hcall_entry and __trace_hcall_exit
> 
> arch/powerpc/kernel/idle.c              |   12 ++----------
> arch/powerpc/platforms/pseries/hvCall.S |    3 ++-
> arch/powerpc/platforms/pseries/lpar.c   |   14 ++++++++++----
> 3 files changed, 14 insertions(+), 15 deletions(-)

Ben,

This doesnt appear to have the compile fix for p1022_ds.c.

- k
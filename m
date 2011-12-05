Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372Ab1LEJ6v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 04:58:51 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51695 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754222Ab1LEJ6u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 04:58:50 -0500
Date: Mon, 5 Dec 2011 10:56:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [GIT PULL] More cleanups for atomic memory operations/spinlocks
Message-ID: <20111205095639.GC9614@elte.hu>
References: <4EB9D48F.5010201@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EB9D48F.5010201@goop.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> I forgot to push these for the just-closed merge window, but they're
> fine for the next one.  Could you find them a home in tip.git?
> 
> Thanks,
>     J
> 
> The following changes since commit 1ea6b8f48918282bdca0b32a34095504ee65bab5:
> 
>   Linux 3.2-rc1 (2011-11-07 16:16:02 -0800)
> 
> are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git upstream/ticketlock-cleanup
> 
> Jeremy Fitzhardinge (2):
>       x86/cmpxchg: add a locked add() helper
>       x86: consolidate xchg and xadd macros
> 
>  arch/x86/include/asm/cmpxchg.h  |  140 +++++++++++++++++++-------------------
>  arch/x86/include/asm/spinlock.h |   15 +----
>  2 files changed, 71 insertions(+), 84 deletions(-)

Pulled it into x86/asm for testing, thanks Jeremy.

Peter, any objections?

Thanks,

	Ingo

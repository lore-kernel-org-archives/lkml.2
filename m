Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534Ab1BVNdy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 08:33:54 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39567 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752096Ab1BVNdx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 08:33:53 -0500
Date: Tue, 22 Feb 2011 14:33:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: yinghai@kernel.org, tglx@linutronix.de, hpa@zytor.com, rientjes@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL tip:x86/mm] x86-64, NUMA: NUMA related misc changes
Message-ID: <20110222133338.GA6493@elte.hu>
References: <20110222112027.GA31267@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110222112027.GA31267@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tejun Heo <tj@kernel.org> wrote:

> Ingo, please pull from the following git branch to receive five
> commits updating x86-64 NUMA code.  These five patches shouldn't cause
> any visible behavior change.  The HEAD is 2bf50555b0 (x86-64, NUMA:
> Seperate out numa_alloc_distance() from numa_set_distance()).
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git x86-numa
> 
> git.korg still seems a bit slow to sync, so if you can't see the HEAD
> there please pull from master.korg.
> 
>   ssh://master.kernel.org/pub/scm/linux/kernel/git/tj/misc.git x86-numa
> 
> Thanks.
> 
> Tejun Heo (3):
>       x86-64, NUMA: Prepare numa_emulation() for moving NUMA emulation into a separate file
>       x86-64, NUMA: Move NUMA emulation into numa_emulation.c
>       x86-64, NUMA: Add proper function comments to global functions
> 
> Yinghai Lu (2):
>       x86-64, NUMA: Do not scan two times for setup_node_bootmem()
>       x86-64, NUMA: Seperate out numa_alloc_distance() from numa_set_distance()
> 
>  arch/x86/mm/Makefile         |    1 +
>  arch/x86/mm/numa_64.c        |  629 +++++++-----------------------------------
>  arch/x86/mm/numa_emulation.c |  475 +++++++++++++++++++++++++++++++
>  arch/x86/mm/numa_internal.h  |   31 ++
>  4 files changed, 607 insertions(+), 529 deletions(-)
>  create mode 100644 arch/x86/mm/numa_emulation.c
>  create mode 100644 arch/x86/mm/numa_internal.h

Pulled, thanks a lot Tejun!

	Ingo

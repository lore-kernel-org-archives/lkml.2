Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841Ab1CERQ5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 12:16:57 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50511 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753467Ab1CERQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 12:16:56 -0500
Date: Sat, 5 Mar 2011 18:16:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: yinghai@kernel.org, tglx@linutronix.de, hpa@zytor.com,
        linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>
Subject: Re: [GIT PULL tip:x86/mm] x86-64 NUMA changes
Message-ID: <20110305171645.GA21673@elte.hu>
References: <20110304155106.GU20499@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110304155106.GU20499@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tejun Heo <tj@kernel.org> wrote:

> Hello, Ingo.
> 
> Please pull from the following git branch to receive x86-64 NUMA
> changes.  It contains four commits.  As discussed before, NUMA affine
> page table allocation is reverted.  Two to fix node0 online assumption
> and one making initmem_init() prettier.
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git x86-mm
> 
> As usual, if HEAD doesn't appear, please pull from master.
> 
>   ssh://master.kernel.org/pub/scm/linux/kernel/git/tj/misc.git x86-mm
> 
> tip:x86/mm contains d04c579f9 (x86: Work around old gas bug) making
> this pull non-fastforward; however, pulling won't generate any
> conflict.
> 
> Thank you.
> 
> David Rientjes (1):
>       x86-64, NUMA: Clean up initmem_init()
> 
> Tejun Heo (2):
>       x86-64, NUMA: Revert NUMA affine page table allocation
>       x86-64, NUMA: Don't assume phys node 0 is always online in numa_emulation()
> 
> Yinghai Lu (1):
>       x86-64, NUMA: Fix numa_emulation code with node0 without RAM
> 
>  arch/x86/include/asm/page_types.h |    2 -
>  arch/x86/kernel/setup.c           |    8 +++
>  arch/x86/mm/init_64.c             |   54 ---------------------
>  arch/x86/mm/numa_64.c             |   96 +++++++++++++++++++++----------------
>  arch/x86/mm/numa_emulation.c      |   20 ++++++--
>  5 files changed, 79 insertions(+), 101 deletions(-)

Thanks, pulled.

	Ingo

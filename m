Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556Ab1CBSPQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 13:15:16 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46521 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755371Ab1CBSPO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 13:15:14 -0500
Date: Wed, 2 Mar 2011 19:15:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: yinghai@kernel.org, tglx@linutronix.de, hpa@zytor.com,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL tip:x86/mm] fixes for memblock build warning and
 numa_distance handling
Message-ID: <20110302181508.GC13693@elte.hu>
References: <20110302172446.GT3319@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110302172446.GT3319@htj.dyndns.org>
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

> Hey, Ingo.
> 
> Please pull from the following git branch to receive two fix patches
> for memblock build warning and numa_distance handling and a patch
> adding comments to numa_distance code.  HEAD is eb8c1e2c83 (x86-64,
> NUMA: Better explain numa_distance handling).
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git x86-mm
> 
> As usual, if HEAD doesn't appear, please pull from master.
> 
>   ssh://master.kernel.org/pub/scm/linux/kernel/git/tj/misc.git x86-mm
> 
> Thanks.
> 
> Tejun Heo (1):
>       x86-64, NUMA: Better explain numa_distance handling
> 
> Yinghai Lu (2):
>       mm: Move early_node_map[] reverse scan helpers under HAVE_MEMBLOCK
>       x86-64, NUMA: Fix distance table handling
> 
>  arch/x86/mm/numa_64.c        |   19 ++++++++----
>  arch/x86/mm/numa_emulation.c |   20 ++++++++----
>  mm/page_alloc.c              |   64 +++++++++++++++++++++---------------------
>  3 files changed, 58 insertions(+), 45 deletions(-)

Pulled, thanks a lot guys!

	Ingo

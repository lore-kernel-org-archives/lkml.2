Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224Ab0HCFnw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 01:43:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43554 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755121Ab0HCFnv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 01:43:51 -0400
Date: Tue, 3 Aug 2010 07:43:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Scott Wood <scottwood@freescale.com>, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org
Subject: Re: Please pull my perf.git master branch
Message-ID: <20100803054337.GA1130@elte.hu>
References: <20100803010412.GA28995@brick.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100803010412.GA28995@brick.ozlabs.ibm.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.5
	-1.0 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1495]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Mackerras <paulus@samba.org> wrote:

> Ingo,
> 
> Please do a pull from my perf.git tree at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/paulus/perf.git master
> 
> to get two commits.  They only affect the driver for the PMU on the
> Freescale embedded PowerPC processors.  One is from Peter Z. and has
> been around for some time.  The other fixes a bug introduced by a
> patch from Peter Z. that I sent upstream recently.
> 
> Thanks,
> Paul.
> 
> Peter Zijlstra (1):
>       perf, powerpc: Convert the FSL driver to use local64_t
> 
> Scott Wood (1):
>       perf, powerpc: fsl_emb: Restore setting perf_sample_data.period
> 
>  arch/powerpc/kernel/perf_event_fsl_emb.c |   29 +++++++++++++++--------------
>  1 files changed, 15 insertions(+), 14 deletions(-)

Pulled, thanks a lot Paul!

	Ingo

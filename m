Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478Ab0ERGef (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 02:34:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49394 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755526Ab0ERGee (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 02:34:34 -0400
Date: Tue, 18 May 2010 08:33:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <bp@alien8.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL, v2] x86/cpu changes for v2.6.35
Message-ID: <20100518063350.GB26223@elte.hu>
References: <20100517225225.GA32562@elte.hu>
 <20100517225426.GA1720@elte.hu>
 <20100518061512.GA17740@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100518061512.GA17740@liondog.tnic>
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


* Borislav Petkov <bp@alien8.de> wrote:

> From: Ingo Molnar <mingo@elte.hu>
> Date: Tue, May 18, 2010 at 12:54:26AM +0200
> 
> Hi Ingo,
> 
> > * Ingo Molnar <mingo@elte.hu> wrote:
> 
> [..]
> 
> >       x86, k8: Fix build error when K8_NB is disabled
> 
> [..]
> 
> >       x86, cacheinfo: Turn off L3 cache index disable feature in virtualized environments
> 
> [..]
> 
> >       powernow-k8: Fix frequency reporting
> 
> those three are already in Linus' tree since they were 
> urgent fixes and had to be sent ASAP. [...]

Yeah, hpa mentioned it last week in his pull request that 
those fixes were picked out of the stream of pending 
development commits.

> [...] Now I don't know whether git will skip them when 
> merging or will cause unneeded merge conflicts (a small 
> superficial test I did here caused merge conflicts) ... 
> anyways, just a heads-up.

In this particular case there will be a conflict in 
arch/x86/kernel/cpu/intel_cacheinfo.c when Linus pulls, 
and the correct resolution is to pick the version from 
x86/cpu.

Thanks for mentioning this!

	Ingo

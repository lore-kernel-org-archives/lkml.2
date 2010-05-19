Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221Ab0ESHOY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 03:14:24 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38498 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753788Ab0ESHOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 03:14:22 -0400
Date: Wed, 19 May 2010 09:13:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       eric.dumazet@gmail.com, "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, Avi Kivity <avi@redhat.com>
Subject: Re: Does anyone care about gcc 3.x support for *x86* anymore?
Message-ID: <20100519071357.GB9618@elte.hu>
References: <4BF33CAD.2070602@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BF33CAD.2070602@zytor.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.5
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4844]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(reposted with Andrew and Linus Cc:-ed too)

* H. Peter Anvin <hpa@zytor.com> wrote:

> [Reposting as a separate thread]
> 
> Recently, we have seen an increasing number of problems 
> with gcc 3.4 on x86; mostly due to poor constant 
> propagation producing not just bad code but failing to 
> properly eliminate what should be dead code.
> 
> I'm wondering if there is any remaining real use of gcc 
> 3.4 on x86 for compiling current kernels (as opposed to 
> residual use for compiling applications on old 
> enterprise distros.)  I'm specifically not referring to 
> other architectures here -- most of these issues have 
> been in relation to low-level arch-specific code, and as 
> such only affects the x86 architectures.  Other 
> architectures may very well have a much stronger need 
> for continued support of an older toolchain.
> 
> If there isn't a reason to preserve support, I would 
> like to consider discontinue support for using gcc 3 to 
> compile x86 kernels.  If there is a valid use case, it 
> would be good to know what it is.
> 
> 	-hpa
> 
> -- 
> H. Peter Anvin, Intel Open Source Technology Center
> I work for Intel.  I don't speak on their behalf.

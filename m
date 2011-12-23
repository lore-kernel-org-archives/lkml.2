Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756700Ab1LWKz5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 05:55:57 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43021 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754069Ab1LWKzz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 05:55:55 -0500
Date: Fri, 23 Dec 2011 11:53:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joro@8bytes.org>
Cc: Avi Kivity <avi@redhat.com>, Robert Richter <robert.richter@amd.com>,
        Benjamin Block <bebl@mageta.org>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>, hpa@zytor.com,
        tglx@linutronix.de, suresh.b.siddha@intel.com, eranian@google.com,
        brgerst@gmail.com, Andreas.Herrmann3@amd.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, Benjamin Block <benjamin.block@amd.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC 4/5] x86, perf: implements lwp-perf-integration (rc1)
Message-ID: <20111223105357.GG4749@elte.hu>
References: <20111220091511.GB3091@elte.hu>
 <4EF05996.8030807@redhat.com>
 <20111220100916.GA20788@elte.hu>
 <20111220152758.GA30127@8bytes.org>
 <20111220184004.GE8408@elte.hu>
 <20111221000716.GB30127@8bytes.org>
 <20111221123442.GB6071@elte.hu>
 <4EF1D4B6.3020408@redhat.com>
 <20111221132233.GB31186@elte.hu>
 <20111221224900.GD30127@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111221224900.GD30127@8bytes.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
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


* Joerg Roedel <joro@8bytes.org> wrote:

> On Wed, Dec 21, 2011 at 02:22:33PM +0100, Ingo Molnar wrote:
> > 
> > * Avi Kivity <avi@redhat.com> wrote:
> > > I hate to re-enter this thread, but this "niche use case" is 
> > > exactly what LWP is designed for. [...]
> > 
> > It's not the only usecase that it can be used in, and that is 
> > what matters to me.
> 
> The really sad thing about it is, that this only matters to 
> you. [...]

What the hell are you talking about? Precise, skid-free profiles 
matter to pretty much *every* single developer profiling 
user-space code on AMD CPUs. That you are not representing them 
properly in this thread qualifies you, not me.

Thanks,

	Ingo

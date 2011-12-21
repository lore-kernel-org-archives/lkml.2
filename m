Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177Ab1LUOnQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 09:43:16 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50530 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751399Ab1LUOnN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 09:43:13 -0500
Date: Wed, 21 Dec 2011 14:22:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: Joerg Roedel <joro@8bytes.org>, Robert Richter <robert.richter@amd.com>,
        Benjamin Block <bebl@mageta.org>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>, hpa@zytor.com,
        tglx@linutronix.de, suresh.b.siddha@intel.com, eranian@google.com,
        brgerst@gmail.com, Andreas.Herrmann3@amd.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, Benjamin Block <benjamin.block@amd.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC 4/5] x86, perf: implements lwp-perf-integration (rc1)
Message-ID: <20111221132233.GB31186@elte.hu>
References: <20111219114023.GB29855@elte.hu>
 <4EEF26F0.1050709@redhat.com>
 <20111220091511.GB3091@elte.hu>
 <4EF05996.8030807@redhat.com>
 <20111220100916.GA20788@elte.hu>
 <20111220152758.GA30127@8bytes.org>
 <20111220184004.GE8408@elte.hu>
 <20111221000716.GB30127@8bytes.org>
 <20111221123442.GB6071@elte.hu>
 <4EF1D4B6.3020408@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EF1D4B6.3020408@redhat.com>
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


* Avi Kivity <avi@redhat.com> wrote:

> On 12/21/2011 02:34 PM, Ingo Molnar wrote:
>
> > I think it can all be supported in a consistent way (see my 
> > previous mails) - but the feature as presented today just 
> > does not look useful enough to me if only supports that 
> > niche self-monitoring usecase.
> 
> I hate to re-enter this thread, but this "niche use case" is 
> exactly what LWP is designed for. [...]

It's not the only usecase that it can be used in, and that is 
what matters to me.

> [...] And once the JVM is adapted to exploit LWP, its use will 
> dwarf all of the uses of perf put together (except the NMI 
> watchdog).  You're only causing the developers needless pain 
> by forcing them to fit this red peg into a green hole.

I disagree - i think LWP has been seriously over-sold and 
seriously under-designed. Anyway, i'm willing to be convinced 
that it's worth to be merged upstream, if it brings tangible 
benefits to the usecases i mentioned.

Thanks,

	Ingo

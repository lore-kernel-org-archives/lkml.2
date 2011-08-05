Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574Ab1HEIWc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 04:22:32 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52967 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924Ab1HEIW2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 04:22:28 -0400
Date: Fri, 5 Aug 2011 10:21:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Len Brown <len.brown@intel.com>,
        Stephen Warren <swarren@nvidia.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: next-200110804 ARM build break (cpuidle_call_idle)
Message-ID: <20110805082113.GA32299@elte.hu>
References: <74CDBE0F657A3D45AFBB94109FB122FF049EEAB704@HQMAIL01.nvidia.com>
 <20110805092941.136089871cddff926cf1dbb7@canb.auug.org.au>
 <20110805105231.7f8abe91210c30580ff40d52@canb.auug.org.au>
 <CA+55aFz1szgUHVLUS=gBM-+FO_PfLYPCDWFNZWZeu8M_M-cbiw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFz1szgUHVLUS=gBM-+FO_PfLYPCDWFNZWZeu8M_M-cbiw@mail.gmail.com>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> [...] In fact, I'm seriously considering a rather draconian measure 
> for next merge window: I'll fetch the -next tree when I open the 
> merge window, and if I get anything but trivial fixes that don't 
> show up in that "next tree at the point of merge window open", I'll 
> just ignore that pull request. Because clearly people are just not 
> being careful enough.

That would be really nice - in hindsight, had you done that in this 
cycle it would have solved about 80% of the merge window bugs i ran 
into!

I have trouble getting my own fixes out on time because -git is so 
untestable at the moment and i need to test on -git now that our new 
bits are upstream.

 [ In fact i'd even argue that the snapshot should be a couple of 
   days _before_ the merge window opening. The trivial annoyances and
   serious showstoppers need a couple of days of latency to get 
   discovered in linux-next and there's always a late rush of getting 
   stuff into linux-next just before the final release. linux-next
   also has weekend latency which can add up to 3 days to the 
   normally 2-3 days latency of discovering showstoppers. ]

People can still try to tempt you with late stuff, with an [RFC GIT 
PULL] tag, clearly and visibly declaring that it's a workflow 
exception and that it's fully discretional on your side with no 
maintenance problems if it's skipped to the next merge window.

Thanks,

	Ingo

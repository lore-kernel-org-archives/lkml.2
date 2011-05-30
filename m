Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757780Ab1E3TYj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 15:24:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60782 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751317Ab1E3TYi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 15:24:38 -0400
Date: Mon, 30 May 2011 21:23:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Brown, Len" <len.brown@intel.com>
Cc: Len Brown <lenb@kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "stable@kernel.org" <stable@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: build warningiIn Linus' tree
Message-ID: <20110530192344.GA5393@elte.hu>
References: <20110530114828.8ef6625b.sfr@canb.auug.org.au>
 <alpine.LFD.2.02.1105292346340.10035@arrandale.kernel.org>
 <20110530073445.GA27557@elte.hu>
 <E87738D94A6AD54789B5B8D1BAEB06CC701ED3BA3E@azsmsx503.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E87738D94A6AD54789B5B8D1BAEB06CC701ED3BA3E@azsmsx503.amr.corp.intel.com>
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


* Brown, Len <len.brown@intel.com> wrote:

> Alan convinced me that the community doesn't move that fast, and 
> that we should wallow in the swill for a while longer before 
> deleting. [...]

Yeah, it's much nicer this way.

> [...] Others volunteered to test the latest upstream kernel on APM 
> hardware, giving APM's presence in the upstream kernel a life line. 
> So all I did was add the recommended feature-removal's and warnings 
> for the stuff which obviously should go.  But if you see some of 
> your favorite bits on the chopping block, you have at least 6 
> months to make a case for them :-)

:-)

I only saw one of the runtime warnings on one of my testboxes - i 
adjusted the boot parameter setting (the parameter was bogus) and 
moved on. So life can go on as far as i'm involved :-)

Thanks,

	Ingo

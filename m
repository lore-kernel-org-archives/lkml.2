Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751929Ab1JRGCp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 02:02:45 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36513 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750936Ab1JRGCo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 02:02:44 -0400
Date: Tue, 18 Oct 2011 08:01:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Simon Kirby <sim@hostway.ca>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: Linux 3.1-rc9
Message-ID: <20111018060104.GA16304@elte.hu>
References: <20111013232521.GA5654@hostway.ca>
 <CA+55aFxxfsFMgqA7kYKukvkCX6Z9HrKOtP-22w5Mc21iQj4c=Q@mail.gmail.com>
 <20111017045806.GA11561@elte.hu>
 <alpine.LFD.2.02.1110171101250.3240@ionos>
 <20111017184916.GA5545@elte.hu>
 <4E9C917B.2050802@zytor.com>
 <20111017211951.GA8043@elte.hu>
 <4E9C9CAE.9090207@zytor.com>
 <20111017213958.GA27126@elte.hu>
 <4E9CA772.4000509@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E9CA772.4000509@zytor.com>
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


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 10/17/2011 02:39 PM, Ingo Molnar wrote:
> >>
> >> We can do much better than that with reciprocal multiplication.  
> > 
> > Yes, 2^64/1e9 is the reciprocal.
> > 
> 
> What I mean is that it's pretty easy to work it so it doesn't have 
> the errors. [...]

Yeah - the second pseudocode i gave will do that with no errors.

> [...] We have 32*32 = 64 multiplication on all 32-bit platforms I'm 
> 99.9% sure.

Good.

Thanks,

	Ingo

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210Ab1EPHcK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 03:32:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51725 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751460Ab1EPHcH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 03:32:07 -0400
Date: Mon, 16 May 2011 09:31:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Jacob Pan <jacob.jun.pan@intel.com>,
        Glauber Costa <glommer@redhat.com>,
        Dimitri Sivanich <sivanich@sgi.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Jeremy Fitzhardinge <jeremy@xensource.com>,
        Chris McDermott <lcm@us.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: linux-next: manual merge of the tip tree with the arm tree
Message-ID: <20110516073144.GF24836@elte.hu>
References: <20110513131437.8999e8eb.sfr@canb.auug.org.au>
 <20110513080634.GA13647@elte.hu>
 <20110513083738.GA19733@n2100.arm.linux.org.uk>
 <20110513092646.GK13647@elte.hu>
 <20110513213640.GB30539@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110513213640.GB30539@n2100.arm.linux.org.uk>
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


* Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> On Fri, May 13, 2011 at 11:26:46AM +0200, Ingo Molnar wrote:
> > Had you asked us before committing it one day after it was posted, or had you 
> > *noticed* that those files are not in your tree and are already modified in 
> > linux-next, you'd have gotten a response like:
> 
> Please also don't read anything into the commit date - it merely shows
> when the last update happened.
>
> My workflow for patch series involves keeping them in git right from the 
> start.  So actually they've been in git since _before_ they were posted. In 
> fact, the emails which I send out for any patch series are always generated 
> from the git commits.
> 
> So, all my patches live in git _first_ before being mailed out.

It is not a problem at all if you commit it to some non-permanent development 
branch of your own - we all do it.

The commit date i pointed out was of the *final* commit, which got into 
linux-next. That showed a timestamp of just a day after the patch was sent
out: presumably you rebased it to add John's Acked-by.

The step where your workflow failed was to take upon yourself to maintain a 
file you do not normally maintain *and* messing up doing that:

 - you did not ask the maintainers who maintain it (which is fine as long as 
   you do not mess up)

 - you did not realize that the file you modified is already modified in that
   tree, almost two months ago (it's not that hard to fetch linux-next once 
   every week or so)

 - you did not even notify them that you committed something so when the bug
   happened in linux-next they had no idea what was going on

Had you done any of those steps differently we'd have a better outcome.

It's not a big problem all and we can resolve it, but you need to stop 
pretending that your workflow was just fine - it sucked here.

Thanks,

	Ingo

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168Ab1EPJSN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 05:18:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52754 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752577Ab1EPJSL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 05:18:11 -0400
Date: Mon, 16 May 2011 11:17:44 +0200
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
Message-ID: <20110516091744.GB12325@elte.hu>
References: <20110513131437.8999e8eb.sfr@canb.auug.org.au>
 <20110513080634.GA13647@elte.hu>
 <20110513083738.GA19733@n2100.arm.linux.org.uk>
 <20110513092646.GK13647@elte.hu>
 <20110513213640.GB30539@n2100.arm.linux.org.uk>
 <20110516073144.GF24836@elte.hu>
 <20110516074230.GI30539@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110516074230.GI30539@n2100.arm.linux.org.uk>
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

> On Mon, May 16, 2011 at 09:31:44AM +0200, Ingo Molnar wrote:
> > 
> > * Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> > 
> > > On Fri, May 13, 2011 at 11:26:46AM +0200, Ingo Molnar wrote:
> > > >
> > > > Had you asked us before committing it one day after it was posted, or 
> > > > had you *noticed* that those files are not in your tree and are already 
> > > > modified in linux-next, you'd have gotten a response like:
> > > 
> > > Please also don't read anything into the commit date - it merely shows 
> > > when the last update happened.
> > >
> > > My workflow for patch series involves keeping them in git right from the 
> > > start.  So actually they've been in git since _before_ they were posted. 
> > > In fact, the emails which I send out for any patch series are always 
> > > generated from the git commits.
> > > 
> > > So, all my patches live in git _first_ before being mailed out.
> > 
> > It is not a problem at all if you commit it to some non-permanent 
> > development branch of your own - we all do it.
> 
> Clearly you're not listening, so no point discussing this further.

Since in the sentence you quote i only repeated what you said above (that you 
keep commits in Git from before when they are posted: i do that too for 
development) i have trouble following your line of thought of how you could 
possibly have concluded that i'm "not listening".

I am very much listening, i just do not agree with what you are saying: i think 
it's pretty clear that details of your Git workflow are broken and need to be 
improved - as demonstrated by the conflict, build breakage and discussion in 
this thread.

Anyway, since you unilaterally stopped discussing this topic and since there's 
no acknowledgement from you that you'll fix your workflow it appears i have no 
choice but to ask you to refrain from modifying any arch/x86/ code in the 
future, without an explicit *prior* ack from one of the x86 maintainers.

When you do that they will be able to guide you through when various files are 
proper to modify in a separate branch and what to do if there are already 
changes in flight.

Thanks,

	Ingo

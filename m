Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023Ab1EPJlb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 05:41:31 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49996 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753933Ab1EPJl3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 05:41:29 -0400
Date: Mon, 16 May 2011 11:40:56 +0200
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
Message-ID: <20110516094056.GA25039@elte.hu>
References: <20110513131437.8999e8eb.sfr@canb.auug.org.au>
 <20110513080634.GA13647@elte.hu>
 <20110513083738.GA19733@n2100.arm.linux.org.uk>
 <20110513092646.GK13647@elte.hu>
 <20110513213640.GB30539@n2100.arm.linux.org.uk>
 <20110516073144.GF24836@elte.hu>
 <20110516074230.GI30539@n2100.arm.linux.org.uk>
 <20110516091744.GB12325@elte.hu>
 <20110516091927.GK30539@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110516091927.GK30539@n2100.arm.linux.org.uk>
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

> On Mon, May 16, 2011 at 11:17:44AM +0200, Ingo Molnar wrote:
> > Since in the sentence you quote i only repeated what you said above (that you 
> > keep commits in Git from before when they are posted: i do that too for 
> > development) i have trouble following your line of thought of how you could 
> > possibly have concluded that i'm "not listening".
> 
> I'm saying you're not listening because I've described the workflow, [...]

And i've said that your workflow is broken for this particular case and you 
have not reacted to my various descriptions of how your workflow is broken in 
this particular case.

> [...] I've told you that what appeared in linux-next was still subject to 
> change, [...]

That's not a proper Git workflow: linux-next is *not* a playing ground to break 
arbitrarily in an *intentional* fashion like that.

linux-next has enough trouble sorting out the *unintentional* breakages and 
spurious conflicts!

Consider linux-next conflicts as a canary for workflow problems. It works very 
well in that regard.

The thing is, if sfr has trouble sorting out the conflict we caused here, while 
he does a dozen conflict resolutions a week 365 days a year, consider the 
workflow problematic by definition ...

So please get your workflow in shape as i suggested:

 - When you seriously modify or move files that other maintainers maintain in
   their trees then you first need to wait for the opinion of those 
   maintainers (and not assume lack of ack after 24 hours means acceptance), or 
   at least you need to *check* linux-next/master whether those files are truly
   quiet in this particular cycle ...

It's only common-sense and not hard to do at all!

That way you can avoid most breakages and conflicts both of technical and 
social nature *before* pushing things to linux-next. As you are doing things 
now you are driving blind in essence, that way you are *asking* for trouble and 
conflicts down the road, and that is sad and i cannot just accept it silently.

I think you are too used to being able to do anything within the ARM Git space 
and getting away with it if you mess up?

If you have a workflow that seriously modifies other trees without realizing 
that those trees have in-flight changes then you have a broken workflow, simple 
as that. And yes, i myself messed up such things in the past as well and 
modified my workflow to handle such things better.

> [...] and yet _you) persist in telling me that what I put in there was the 
> "final" commit. [...]

Yes, because you pushed it out for others to see and it showed up in 
linux-next?

Thanks,

	Ingo

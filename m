Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752251Ab1EPHWL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 03:22:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34960 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751911Ab1EPHWJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 03:22:09 -0400
Date: Mon, 16 May 2011 09:21:34 +0200
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
Message-ID: <20110516072134.GE24836@elte.hu>
References: <20110513131437.8999e8eb.sfr@canb.auug.org.au>
 <20110513080634.GA13647@elte.hu>
 <20110513083738.GA19733@n2100.arm.linux.org.uk>
 <20110513092646.GK13647@elte.hu>
 <20110513172509.GC19733@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110513172509.GC19733@n2100.arm.linux.org.uk>
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
> > Also note that there's also some pending changes in the x86 tree modifying
> > arch/x86/kernel/i8253.c:
> > 
> >   b01cc1b0eae0: x86: Convert remaining x86 clocksources to clocksource_register_hz/khz
> > 
> > If you want to do any further change to this file you need to pull in this 
> > change first or need to resolve the conflict in some other way.
> 
> I have been told by Linus on more than one occasion that Linus wants to
> see exactly these kinds of merge conflicts, as it helps him track what's
> going on.

He has told us on more than one occasion that he wants to see *easy* conflicts, 
where he can see benign interaction between properly maintained trees.

Here he would look and would only determine what i have already determined: 
that the workflow of applying this patch sucked. That is definitely not the 
kind of conflict Linus wants to see in the merge window ...

You applied the patch without talking to the maintainers who are running the 
affected tree. You talked to one of the developers which is fine, and i will 
generally ack it in hindsight if you do a fine job of sorting out the details - 
but here you touched an under-modification file without even realizing it. So 
you messed up which fact i will keep pointing out and i will keep asking you to 
fix your workflow, so that similar mistakes wont happen in the future.

Really, Russell, you sometimes need to accept blame and you need to admit when 
you messed up instead of writing countless mails trying to save face and 
wriggle out of it. I mess up all the time and my hand does not rot away from 
writing this. Really, write this down: "You are right, I messed this up a bit, 
lets fix it instead of wasting time on emails."

Lets resolve the conflict and move on, okay?

Thanks,

	Ingo

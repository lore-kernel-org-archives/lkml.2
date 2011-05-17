Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754457Ab1EQL4o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 07:56:44 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56592 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753939Ab1EQL4m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 07:56:42 -0400
Date: Tue, 17 May 2011 13:56:14 +0200
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
Message-ID: <20110517115614.GG13475@elte.hu>
References: <20110513092646.GK13647@elte.hu>
 <20110513213640.GB30539@n2100.arm.linux.org.uk>
 <20110516073144.GF24836@elte.hu>
 <20110516074230.GI30539@n2100.arm.linux.org.uk>
 <20110516091744.GB12325@elte.hu>
 <20110516091927.GK30539@n2100.arm.linux.org.uk>
 <20110516094056.GA25039@elte.hu>
 <20110516100750.GN30539@n2100.arm.linux.org.uk>
 <20110516110652.GC19837@elte.hu>
 <20110516113707.GQ30539@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110516113707.GQ30539@n2100.arm.linux.org.uk>
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

> On Mon, May 16, 2011 at 01:06:52PM +0200, Ingo Molnar wrote:
> > 
> > * Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> > 
> > > On Mon, May 16, 2011 at 11:40:56AM +0200, Ingo Molnar wrote:
> > > >    maintainers (and not assume lack of ack after 24 hours means acceptance), or 
> > > 
> > > Wrong, 72 to 96 hours.  Sunday to Wednesday/Thursday.
> > 
> > Not that this is really material (the argument is pretty much the same even had 
> > you waited 3 days), but you are already wrong about the 'Sunday' part, because 
> > you posted it to lkml on *Monday* 13:27 GMT:
> > 
> >         Message-ID: <20110509132738.GB16919@n2100.arm.linux.org.uk>
> >         Mon, 9 May 2011 09:27:52 -0400
> 
> Sigh.  So you're only looking at the _second_ posting of them, not the first.
>
> Here's the message, minus the patch.
> 
> | Date: Sun, 8 May 2011 19:24:07 +0100
> | From: Russell King - ARM Linux <linux@arm.linux.org.uk>
> | To: Ralf Baechle <ralf@linux-mips.org>, John Stultz <johnstul@us.ibm.com>,
> |         "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>
> | Subject: i8253 clocksource consolidation
> | Message-ID: <20110508182407.GN27807@n2100.arm.linux.org.uk>
> | 
> | Ralf, John, Ingo, hpa,

I did not get that mail, at all. It's not in my spam mbox either.

This pretty much explains why you assumed us informed and should explain to you 
why i was surprised by your way of handling the patch :-)

Thanks,

	Ingo

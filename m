Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756280Ab1EQS3q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 14:29:46 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40465 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756133Ab1EQS3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 14:29:45 -0400
Date: Tue, 17 May 2011 19:28:12 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Ingo Molnar <mingo@elte.hu>
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
Message-ID: <20110517182812.GA2266@n2100.arm.linux.org.uk>
References: <20110513213640.GB30539@n2100.arm.linux.org.uk> <20110516073144.GF24836@elte.hu> <20110516074230.GI30539@n2100.arm.linux.org.uk> <20110516091744.GB12325@elte.hu> <20110516091927.GK30539@n2100.arm.linux.org.uk> <20110516094056.GA25039@elte.hu> <20110516100750.GN30539@n2100.arm.linux.org.uk> <20110516110652.GC19837@elte.hu> <20110516113707.GQ30539@n2100.arm.linux.org.uk> <20110517115614.GG13475@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110517115614.GG13475@elte.hu>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 17, 2011 at 01:56:14PM +0200, Ingo Molnar wrote:
> * Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> 
> > On Mon, May 16, 2011 at 01:06:52PM +0200, Ingo Molnar wrote:
> > > 
> > > * Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> > > 
> > > > On Mon, May 16, 2011 at 11:40:56AM +0200, Ingo Molnar wrote:
> > > > >    maintainers (and not assume lack of ack after 24 hours means acceptance), or 
> > > > 
> > > > Wrong, 72 to 96 hours.  Sunday to Wednesday/Thursday.
> > > 
> > > Not that this is really material (the argument is pretty much the same even had 
> > > you waited 3 days), but you are already wrong about the 'Sunday' part, because 
> > > you posted it to lkml on *Monday* 13:27 GMT:
> > > 
> > >         Message-ID: <20110509132738.GB16919@n2100.arm.linux.org.uk>
> > >         Mon, 9 May 2011 09:27:52 -0400
> > 
> > Sigh.  So you're only looking at the _second_ posting of them, not the first.
> >
> > Here's the message, minus the patch.
> > 
> > | Date: Sun, 8 May 2011 19:24:07 +0100
> > | From: Russell King - ARM Linux <linux@arm.linux.org.uk>
> > | To: Ralf Baechle <ralf@linux-mips.org>, John Stultz <johnstul@us.ibm.com>,
> > |         "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>
> > | Subject: i8253 clocksource consolidation
> > | Message-ID: <20110508182407.GN27807@n2100.arm.linux.org.uk>
> > | 
> > | Ralf, John, Ingo, hpa,
> 
> I did not get that mail, at all. It's not in my spam mbox either.
> 
> This pretty much explains why you assumed us informed and should explain to you 
> why i was surprised by your way of handling the patch :-)

I never got a bounce either.  Here's my outgoing MTA log lines for that
message:

2011-05-08 19:24:10 1QJ8eH-0004Rc-GR <= linux@arm.linux.org.uk
 H=n2100.arm.linux.org.uk [2002:4e20:1eda:1:214:fdff:fe10:4f86]
 I=[2002:4e20:1eda:1:a00:2bff:fe95:1d7b]:25 P=esmtpsa
 X=TLSv1:AES256-SHA:256 A=cram:n2100.arm.linux.org.uk S=16326
 id=20110508182407.GN27807@n2100.arm.linux.org.uk
 T="i8253 clocksource consolidation" for ralf@linux-mips.org
 johnstul@us.ibm.com hpa@zytor.com mingo@redhat.com
2011-05-08 19:24:54 1QJ8eH-0004Rc-GR => mingo@redhat.com R=verp_dnslookup
 T=verp_smtp S=16866 H=mx1.redhat.com [209.132.183.28] C="250 2.0.0
 p48IOnv1008509 Message accepted for delivery"

So, mx1.redhat.com accepted it...  In theory, whoever has access to
mx1.redhat.com's logs should be able to trace what happened to the
message...

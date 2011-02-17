Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869Ab1BQJl2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 04:41:28 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:37805 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752696Ab1BQJlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 04:41:24 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18u3XU+iV8ucfEt5lQ60efGYbqdc/inxqa8un5Lpi
	pow2jtRFQWo5rI
Subject: Re: Patch "sched: Give CPU bound RT tasks preference" has been
 added to the 2.6.32-longterm tree
From: Mike Galbraith <efault@gmx.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Jiri Slaby <jirislaby@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, gregkh@suse.de,
        srostedt <srostedt@redhat.com>, a.p.zijlstra@chello.nl,
        ghaskins@novell.com, stable@kernel.org, stable-commits@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20110217085219.417ba829@stein>
References: <12978046423644@kroah.org>
	 <1297810967.23343.122.camel@gandalf.stny.rr.com>
	 <1297821667.5126.11.camel@marge.simson.net>
	 <20110216082559.GA16529@elte.hu> <4D5B90E8.6080605@gmail.com>
	 <1297849553.5275.29.camel@marge.simson.net> <20110216152906.75d4000c@stein>
	 <1297919107.6361.59.camel@marge.simson.net> <20110217085219.417ba829@stein>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Feb 2011 10:41:08 +0100
Message-ID: <1297935668.5411.21.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-17 at 08:52 +0100, Stefan Richter wrote:
> On Feb 17 Mike Galbraith wrote:
> > On Wed, 2011-02-16 at 15:29 +0100, Stefan Richter wrote:
> > > Jiri,
> > > if the desire is to improve performance of existing features (and maybe
> > > add this and that little feature that looks attractive), while at the same
> > > time you want
> > >   - experts to have looked at these improvements,
> > >   - packagers to avoid duplicate work,
> > >   - keep the number of local patches in check,
> > > then the solution is to /stay close enough to the mainline/.
> 
> [By which I meant updating, not backporting.]

[but you know that ain't an option too]

> > People are fixing this and that in their enterprise kernels privately
> > every day.  The only difference between that, and pushing baked fixes
> > back is that pushing to stable is visible.  I strongly suspect that
> > there are just tons of mainline backports sitting in each and every
> > enterprise tree in existence.
> 
> 'Visible' = the change which was an important performance improvement or
> outright fix at site A (and a nice-to-have improvement on sites B...X)
> eventually exhibits a regression at site Y.

Known bugs are stable bugs, known performance problems are stable
performance problems is the only answer to that.  Leaving them as is
does remove risk of a customer satisfaction delta.. but..  

But whatever.  Yeah, I understand that it's a sticky wicket.

	-Mike


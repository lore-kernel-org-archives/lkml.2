Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577Ab1BQHw6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 02:52:58 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:35635 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603Ab1BQHw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 02:52:56 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 17 Feb 2011 08:52:19 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Mike Galbraith <efault@gmx.de>
Cc: Jiri Slaby <jirislaby@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, gregkh@suse.de,
        srostedt <srostedt@redhat.com>, a.p.zijlstra@chello.nl,
        ghaskins@novell.com, stable@kernel.org, stable-commits@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Patch "sched: Give CPU bound RT tasks preference" has been
 added to the 2.6.32-longterm tree
Message-ID: <20110217085219.417ba829@stein>
In-Reply-To: <1297919107.6361.59.camel@marge.simson.net>
References: <12978046423644@kroah.org>
	<1297810967.23343.122.camel@gandalf.stny.rr.com>
	<1297821667.5126.11.camel@marge.simson.net>
	<20110216082559.GA16529@elte.hu>
	<4D5B90E8.6080605@gmail.com>
	<1297849553.5275.29.camel@marge.simson.net>
	<20110216152906.75d4000c@stein>
	<1297919107.6361.59.camel@marge.simson.net>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 17 Mike Galbraith wrote:
> On Wed, 2011-02-16 at 15:29 +0100, Stefan Richter wrote:
> > Jiri,
> > if the desire is to improve performance of existing features (and maybe
> > add this and that little feature that looks attractive), while at the same
> > time you want
> >   - experts to have looked at these improvements,
> >   - packagers to avoid duplicate work,
> >   - keep the number of local patches in check,
> > then the solution is to /stay close enough to the mainline/.

[By which I meant updating, not backporting.]

> That's the intent of pushing more than _purely_ critical bugfixes, get a
> bit closer.  Enterprise can't move as fast as mainline, not even close,
> that's a given.  Stable problem get griped about though, so there's no
> choice but to take some risk.  The tricky bit is how much, and how you
> go about it.

Granted.

> People are fixing this and that in their enterprise kernels privately
> every day.  The only difference between that, and pushing baked fixes
> back is that pushing to stable is visible.  I strongly suspect that
> there are just tons of mainline backports sitting in each and every
> enterprise tree in existence.

'Visible' = the change which was an important performance improvement or
outright fix at site A (and a nice-to-have improvement on sites B...X)
eventually exhibits a regression at site Y.
-- 
Stefan Richter
-=====-==-== --=- =---=
http://arcgraph.de/sr/

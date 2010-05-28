Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757806Ab0E1Jaq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 05:30:46 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49243 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753930Ab0E1Jao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 05:30:44 -0400
Date: Fri, 28 May 2010 10:37:13 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: tytso@mit.edu
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100528103713.0a7952d9@lxorguk.ukuu.org.uk>
In-Reply-To: <20100528043114.GC26177@thunk.org>
References: <20100527222514.0a1710bf@lxorguk.ukuu.org.uk>
	<Pine.LNX.4.44L0.1005271730180.3239-100000@iolanthe.rowland.org>
	<20100527230806.4deb6de3@lxorguk.ukuu.org.uk>
	<20100527220949.GB10602@srcf.ucam.org>
	<20100527232357.6d14fdb2@lxorguk.ukuu.org.uk>
	<20100527223605.GB11364@srcf.ucam.org>
	<20100527235546.09f3ce8a@lxorguk.ukuu.org.uk>
	<20100528043114.GC26177@thunk.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Keep in mind, though, that a solution which is acceptable for Android
> has to include making sure that crappy applications don't cause the

Ted if you are speaking for Android do you think you should post from a
google address or with a google .sig ?

> battery to get drained.  There seem to be some people who seem
> adamently against this requirement.  From the Android folks'
> perspective, this is part of what is required to have an open app
> store, as opposed to one where each application has to be carefully
> screened and approved ala the Apple iPhone App Store.

The other vendors appear to be managing nicely without magic blockers. I
conjecture therefore there are other solutions.

> We need to agree on the requirements up front, because otherwise this
> is going to be a waste of everyone's time.

This is why I am trying to understand the problem properly.

> And if we can't get agreement on requirements, I'd suggest appealing
> this whole thing to Linus.  Either he'll agree to the requirements
> and/or the existing implementation, in which case we can move on with

The existing implementation has been comprehensively rejected by half the
x86 maintainers and scheduler people to start with. That's a fairly big
'No'.

> our lives, or he'll say no, in which case it will be blately obvious
> that it was Linux developer community who rejected the Android
> approach, despite a fairly large amount of effort trying to get
> something that satisfies *all* of the various LKML developers who have

Ted save the politicing and blame mongering for management meetings
please.

If we don't have a solution it means that between us we couldn't find a
viable solution. Maybe there isn't one, maybe we missed it. It's as much
'google rejects kernel approach' as 'kernel rejects google approach' and
more importantly its actually 'we (cumulative) were not smart enough
between us to figure it out'

> P.S.  Keep in mind how this looks from an outsider's perspective; an
> embedded manufacturer spends a fairly large amount of time answering
> one set of review comments, and a few weeks later, more people pop up,
> and make a much deeper set of complaints, and request that the current
> implementation be completely thrown out and that someone new be
> designed from scratch --- and the new design isn't even going to meet
> all of the requirements that the embedded manufacturer thought were
> necessary.  Is it any wonder a number of embedded developers have
> decided it's Just Too Hard to Work With the LKML?

In some cases it is easier to do stuff yourself than work with others.
One of the conditions of working in a public space is that you do so
without harming others. This is why in much of the western world you can
drive a car around your own land without a licence but must have one to
drive on a public road. This is why a restuarant must meet different food
standards to a home kitchen. This is why the kernel standards are higher
than what you go off and do in private.

Android is a very unique and extremely narrow environment. If it really
is special enough to need its own kernel fork it isn't the first case for
that and it's not a problem. The GPL is quite happy to encourage this.
Time will then answer the questions because in 3 years time either every
non Google phone will be kicking butt without suspend blockers, or every
phone vendor using Linux with a traditional user space will be demanding
them.

Alan

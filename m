Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539Ab0FCPln (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 11:41:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:52804 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756126Ab0FCPll convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 11:41:41 -0400
Subject: Re: [PATCH] - race-free suspend. Was: Re: [linux-pm] [PATCH 0/8]
 Suspend block api (version 8)
From: Peter Zijlstra <peterz@infradead.org>
To: tytso@mit.edu
Cc: Brian Swetland <swetland@google.com>, Neil Brown <neilb@suse.de>,
       Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       "Paul@smtp1.linux-foundation.org" <Paul@smtp1.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       James Bottomley <James.Bottomley@suse.de>
In-Reply-To: <20100603142150.GB13179@thunk.org>
References: <20100601113309.609349fd@notabene.brown>
	 <alpine.LFD.2.00.1006010340160.2933@localhost.localdomain>
	 <20100601122012.1edeaf48@notabene.brown>
	 <alpine.LFD.2.00.1006011243350.2933@localhost.localdomain>
	 <20100602153235.340a7852@notabene.brown>
	 <AANLkTikVjAf5nHdMx2bcHRAUSkq99s-b5YZCECXIJJLy@mail.gmail.com>
	 <20100602180614.729246ea@notabene.brown>
	 <AANLkTikXy__71nBNW0EFbyL_qNf0nQ68pW9KymWlTk7L@mail.gmail.com>
	 <20100603163307.721b1c23@notabene.brown>
	 <AANLkTikuf6bKVHoGRTjrM_2kPtZqUM6J76Z0hNUQxT_3@mail.gmail.com>
	 <20100603142150.GB13179@thunk.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 03 Jun 2010 17:41:41 +0200
Message-ID: <1275579701.27810.36036.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-03 at 10:21 -0400, tytso@mit.edu wrote:

> And let's be blunt.  If in the future the Android team (which I'm not
> a member of) decides that they have invested more engineering time
> than they can justify from a business perspective, the next time
> someone starts whining on a blog, or on Slashdot, or at a conference,
> about how "OMG!  Google is forking the kernel!!!", or "Google is
> making the lives of device driver writers for the embedded world
> difficult", it will now be possible from a political point of view to
> point and the hundreds, if not thousands, of e-mail messages of LKML
> developers wanting to redesign this effort and saying "Nyet!  Nyet!
> Nyet!" to the original patchset, to point out that Google has a made
> an effort, and gone far beyond what is required by the GPL.  Not only
> has the source code been made available, but hundreds of engineering
> hours have been made trying to accomodate the demands of LKML --- and
> LKML has said no to suspend blockers/wakelocks.


In the spirit of being blunt, so what?

We say no for good technical reasons. Also when did it become sensible
to push features after they were shipped?

It never works to develop stuff like this out-of-tree and then push for
inclusion. You always get to rewrite (at least 3 times).

If Google indeed decides it doesn't want to play upstream, then sad. But
I don't see how we would be unjust in complaining about it.

There is more to our community than the letter of the GPL, and you
should know that. So I really don't see the point of your argument (was
there one besides the management gibberish?).

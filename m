Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803Ab0HPLj3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 07:39:29 -0400
Received: from esgaroth.petrovitsch.at ([78.47.184.11]:2584 "EHLO
	esgaroth.petrovitsch.priv.at" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751114Ab0HPLj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 07:39:27 -0400
X-DKIM: Sendmail DKIM Filter v2.8.3 unknown-host o7GBau64014102
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
From: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Ted Ts'o" <tytso@mit.edu>, Felipe Contreras <felipe.contreras@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, paulmck@linux.vnet.ibm.com,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, david@lang.hm,
        Brian Swetland <swetland@google.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, florian@mickler.org,
        rjw@sisk.pl, peterz@infradead.org, tglx@linutronix.de,
        menage@google.com, david-b@pacbell.net, James.Bottomley@suse.de,
        arjan@infradead.org, swmike@swm.pp.se, galibert@pobox.com,
        dipankar@in.ibm.com
In-Reply-To: <20100814075000.GB27430@elf.ucw.cz>
References: <AANLkTikcoWfmL-XfYbFeYdVtU9GC6_LtVSSB2H6GcedA@mail.gmail.com>
	 <Pine.LNX.4.44L0.1008120733130.21006-100000@netrider.rowland.org>
	 <AANLkTinMwt27wuDUh32F36wpoC54Syzp1_nK9UCxYmEK@mail.gmail.com>
	 <20100812125248.GA2763@thunk.org>  <20100814075000.GB27430@elf.ucw.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 Aug 2010 13:36:56 +0200
Message-ID: <1281958616.17267.2.camel@thorin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 8bit
X-DCC-dcc1-Metrics: esgaroth.petrovitsch.priv.at; whitelist
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sam, 2010-08-14 at 09:50 +0200, Pavel Machek wrote:
> On Thu 2010-08-12 08:52:49, Ted Ts'o wrote:
> > On Thu, Aug 12, 2010 at 03:28:01PM +0300, Felipe Contreras wrote:
> > > 
> > > The question is why are we adding a user-space API that:
> > >  1) no user-space beside Android has expresses interest in implementing
> > >  2) is dubious whether the benefits are worth the pain for non-Android
> > > user-space
> > >  3) will become less and less attractive as dynamic PM gets closer to
> > > the sweet-spot, and then surpass it
> > >  4) Android can keep in a separate tree until it's clear in the linux
> > > community that it's useful (if it ever happens)
> > 
> > So, Felipe,
> > 
> > Do you believe you speak for all of LKML?
[...]
> And yes, for the record Felipe speaks for me pretty well.

Not that I´m as "valuable" as the others quoted above: I have the same
impression.

> Normal path of merging stuff to the kernel is
> 
> "Google develops it, then modifies it to address the review comments,
> then it is merged, then it is deployed".
> 
> Unfortunately what Google did here is:
> 
> "Google develops it behind the closed door, then deploys it. When
> asked for changes, Google expects someone else to create system
> compatible with their existing solution, or else their patches being
> merged."

That basically sums it up as far as I see.

	Bernd
-- 
Bernd Petrovitsch                  Email : bernd@petrovitsch.priv.at
                     LUGA : http://www.luga.at


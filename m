Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757684Ab0HQPdS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 11:33:18 -0400
Received: from THUNK.ORG ([69.25.196.29]:59373 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753860Ab0HQPdQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 11:33:16 -0400
Date: Tue, 17 Aug 2010 11:33:04 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Neil Brown <neilb@suse.de>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Pavel Machek <pavel@ucw.cz>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, paulmck@linux.vnet.ibm.com,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, david@lang.hm,
        Brian Swetland <swetland@google.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, florian@mickler.org,
        rjw@sisk.pl, peterz@infradead.org, tglx@linutronix.de,
        menage@google.com, david-b@pacbell.net, James.Bottomley@suse.de,
        arjan@infradead.org, swmike@swm.pp.se, galibert@pobox.com,
        dipankar@in.ibm.com
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
Message-ID: <20100817153304.GI21182@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>, Neil Brown <neilb@suse.de>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Pavel Machek <pavel@ucw.cz>,
	Felipe Contreras <felipe.contreras@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>, paulmck@linux.vnet.ibm.com,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, david@lang.hm,
	Brian Swetland <swetland@google.com>,
	linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
	arve@android.com, mjg59@srcf.ucam.org, florian@mickler.org,
	rjw@sisk.pl, peterz@infradead.org, tglx@linutronix.de,
	menage@google.com, david-b@pacbell.net, James.Bottomley@suse.de,
	arjan@infradead.org, swmike@swm.pp.se, galibert@pobox.com,
	dipankar@in.ibm.com
References: <AANLkTikcoWfmL-XfYbFeYdVtU9GC6_LtVSSB2H6GcedA@mail.gmail.com>
 <Pine.LNX.4.44L0.1008120733130.21006-100000@netrider.rowland.org>
 <AANLkTinMwt27wuDUh32F36wpoC54Syzp1_nK9UCxYmEK@mail.gmail.com>
 <20100812125248.GA2763@thunk.org>
 <20100814075000.GB27430@elf.ucw.cz>
 <20100816081655.3e9e29f7@virtuousgeek.org>
 <20100817002032.GD21182@thunk.org>
 <20100817170858.3c3385f7@notabene>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100817170858.3c3385f7@notabene>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 05:08:58PM +1000, Neil Brown wrote:
> 
> Maybe this is the first real fork of Linux - google might be rich enough to
> persist with it.

Define "real fork"?  Both SuSE and Red Hat have carried patches, in
some cases for years, forward porting them to newer kernels.  Does
that make them forks?

SuSE has made changes to e2fsprogs, and carried those patches for
years and years, and even added options to command-line programs which
SLES's init scripts are dependent on --- and this was done without
even consulting me first.  Yet you don't see me calling out SLES for
"forking" e2fsprogs and how it "got away" with it.

Can we please cut out this whole forking nonsense?  I've been told
that it's only something Slashdot kiddies and ZDNet media types
looking for advertising impressions.  Yet you're a kernel programmer,
and one who works for a distribution, and you've made this same claim;
you should know better.

> I'm surprised at this comment Ted!
> Power saving is not the single supreme goal, yet you make it sound like
> it is.
> 
> It should be no surprise to anyone if the most maintainable solution uses a
> little more power than the most highly optimised solution.  I think most of
> us would still prefer the more maintainable solution.

I think part of the problem here is what's considered "acceptable" to
one set of developers may not be considered "acceptable" to another
set.  As I've said many times before, what makes sense for a cell
phone battery and highly power-optimized hardware may not make sense
for a devices with 6-cell laptop battery.  And I think it's still to
be seen whether or not suspend-from-userspace really is as minor as
people think it is, and what compromises might have to be made in how
app programs are forced to develop their applications, etc.

							- Ted

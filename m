Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877Ab0I1EWk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 00:22:40 -0400
Received: from thunk.org ([69.25.196.29]:54313 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750702Ab0I1EWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 00:22:39 -0400
Date: Tue, 28 Sep 2010 00:22:28 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Joe Perches <joe@perches.com>
Cc: Florian Mickler <florian@mickler.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Wolfram Sang <w.sang@pengutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: RFC: get_maintainer.pl: append reason for cc to the name by
 default
Message-ID: <20100928042228.GB7865@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>, Joe Perches <joe@perches.com>,
	Florian Mickler <florian@mickler.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Stephen Hemminger <shemminger@vyatta.com>,
	Wolfram Sang <w.sang@pengutronix.de>, linux-kernel@vger.kernel.org
References: <1284111212-10659-1-git-send-email-florian@mickler.org>
 <1285527125.1732.24.camel@Joe-Laptop>
 <20100927165748.354742f2@schatten.dmk.lab>
 <20100927154441.GE3602@thunk.org>
 <20100927190026.20ddc268@schatten.dmk.lab>
 <20100927182124.GA3168@thunk.org>
 <20100927212650.62859ee0@schatten.dmk.lab>
 <1285618097.1732.204.camel@Joe-Laptop>
 <20100927204756.GC3168@thunk.org>
 <1285622205.4725.34.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285622205.4725.34.camel@Joe-Laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 27, 2010 at 02:16:45PM -0700, Joe Perches wrote:
> 
> Tell me something Ted.  Have you in the last 5 years or
> so done any work in the kernel outside of fs or modified
> files outside of fs when fs structures weren't changed?

Yes, I have.  And when I needed to figure out who to send my patches
to, I used "git log" to figure out where to send it.  Quite frankly it
was easier than using the MAINTAINERS file, just because it was
faster.  But I was a human, so I could filter out the trivial cleanup
patches, and I could do a better job figuring out how to pick out the
right information from git log output.  (And Linus was suggesting that
a human do it, not some script that takes anyone who has 5% of the
signoffs, even if that's only a single signoff.  Sigh.)

> Are you representative of the typical user of a script like
> get_maintainer or checkpatch?  Does it matter that much?

Well, I think I know something about good pedagogy for teaching
newcomers to the kernel development process how to be good kernel
developers.  And I think get_maintainers and checkpatch.pl --file are
really horrible pedogagical tools.  You really want to teach people
how to look through "git log" output.  You don't want them relying on
scripts.

Note that there are web pages out there with comments where people
have advertised scripts they have written which attempt to automate
trivial whitespace cleanups, and where users are bragging that "they
got their name in the Linux kernel" --- and they're using
get_maintainer.pl as a way of automating how to send it these trivial
patches just so they can say they have contributed something to the
kernel.  OK, we want to be welcoming people to be kernel developers
--- but do we really think this is really a good way of doing it?

Who do *you* think is the typical user of a script like
get_maintainer.pl?  Someone who is just trying to do a "kilroy was
here" in git?  Someone who is genuinely trying to learn how to
contribute positive value to Linux?  A regular kernel maintainer?

Given that the currently published version has extra cc lines, I
certainly won't use it in its current form.  And it's really not that
hard to look things up in MAINTAINERS or to use git log.  Heck, before
I make a change to file I generally want to look to see what sort of
recent changes there have been to the file in the first place.

And if it's a genuine newcomer who is interested in learning, again,
is get_maintainer.pl really doing them a service?  If so, what do you
think that service is?  I don't think a crutch which actively
discourages them from looking through MAINTAINERS or "git log" is in
fact a good thing --- for anyone.

						- Ted

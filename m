Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760232Ab0I0UsJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 16:48:09 -0400
Received: from thunk.org ([69.25.196.29]:58013 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755319Ab0I0UsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 16:48:07 -0400
Date: Mon, 27 Sep 2010 16:47:56 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Joe Perches <joe@perches.com>
Cc: Florian Mickler <florian@mickler.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Wolfram Sang <w.sang@pengutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: RFC: get_maintainer.pl: append reason for cc to the name by
 default
Message-ID: <20100927204756.GC3168@thunk.org>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285618097.1732.204.camel@Joe-Laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 27, 2010 at 01:08:17PM -0700, Joe Perches wrote:
> On Mon, 2010-09-27 at 21:26 +0200, Florian Mickler wrote:
> > But we should definitely try to tune down the annoying part of
> > it by making it less random and maybe by adding a tag in the cc field...
> 
> Less random: sure, whatever's reasonable.
> 
> I still think that tagging the name portion of an email address
> is not a good idea, especially without some way of turning it
> off.  Maybe a mechanism to optionally enable it would be ok.

Well, at the moment, what is currently shipping in git-head and 2.6.35
does such an __awful__ job that I think a lot of people would be a lot
happier if we could get the e-mail messages tagged.  Maybe the call
for that would be less if some of queued fixes for get_maintainer.pl
could get pushed out more quickly, or you made an out-of-tree version
of get_mainatiner.pl so that fixes could get pushed to the newbies
more quickly.

Still, if as you argue, the heuristic guessing from the git repository
becomes something which will (eventually) be rarely done, then what
harm does it done if when those time that get_maintainer.pl is
guessing wildly by trying to read git history, those e-mail names are
tagged?

I'd argue that users shouldn't be using get_maintainer.pl in scripts.
Those who use them properly can always cut away the tags.  If someone
is lazy enough to be using get_maintainer.pl in a script to send
e-mail, then I think it's only fair and transparent that the fact that
(a) they are using get_maintainer in a script, and (b)
get_maintainer.pl was forced to guess would be a good thing.

Think about it this way; if we see something to LKML with an a
get_maintainer.pl tag indicating that it had to guess, it's a hint
that the MAINTAINERS file needs to be updated?  Wouldn't that be a
valuable way of notifying people of that fact?   :-)

	     		  	    	 - Ted

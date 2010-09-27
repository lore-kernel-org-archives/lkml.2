Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759116Ab0I0VQt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 17:16:49 -0400
Received: from mail.perches.com ([173.55.12.10]:2485 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752844Ab0I0VQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 17:16:48 -0400
Subject: Re: RFC: get_maintainer.pl: append reason for cc to the name by
 default
From: Joe Perches <joe@perches.com>
To: "Ted Ts'o" <tytso@mit.edu>
Cc: Florian Mickler <florian@mickler.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Wolfram Sang <w.sang@pengutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20100927204756.GC3168@thunk.org>
References: <1284111212-10659-1-git-send-email-florian@mickler.org>
	 <1285527125.1732.24.camel@Joe-Laptop>
	 <20100927165748.354742f2@schatten.dmk.lab>
	 <20100927154441.GE3602@thunk.org>
	 <20100927190026.20ddc268@schatten.dmk.lab>
	 <20100927182124.GA3168@thunk.org>
	 <20100927212650.62859ee0@schatten.dmk.lab>
	 <1285618097.1732.204.camel@Joe-Laptop>  <20100927204756.GC3168@thunk.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Sep 2010 14:16:45 -0700
Message-ID: <1285622205.4725.34.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-27 at 16:47 -0400, Ted Ts'o wrote:
> On Mon, Sep 27, 2010 at 01:08:17PM -0700, Joe Perches wrote:
> > On Mon, 2010-09-27 at 21:26 +0200, Florian Mickler wrote:
> > > But we should definitely try to tune down the annoying part of
> > > it by making it less random and maybe by adding a tag in the cc field...
> > Less random: sure, whatever's reasonable.
> > I still think that tagging the name portion of an email address
> > is not a good idea, especially without some way of turning it
> > off.  Maybe a mechanism to optionally enable it would be ok.
> Well, at the moment, what is currently shipping in git-head and 2.6.35
> does such an __awful__ job that I think a lot of people would be a lot
> happier if we could get the e-mail messages tagged.

Ridiculous exaggeration.  The script doesn't do an _awful_ job.

It includes what some vocal sorts consider suboptimal additional
cc's in some circumstances.  It has for the last year and a half.

Those cc's generally take _seconds_ for a cc'd party to ignore.

> Maybe the call
> for that would be less if some of queued fixes for get_maintainer.pl
> could get pushed out more quickly, or you made an out-of-tree version
> of get_mainatiner.pl so that fixes could get pushed to the newbies
> more quickly.

I already posted the tree.
http://lkml.org/lkml/2010/9/22/464
http://repo.or.cz/w/linux-2.6/get_maintainer.git

> Wouldn't that be a
> valuable way of notifying people of that fact?   :-)

Not really, and it just makes email message threading uglier.

A lot of these are already known.  I've told you multiple
times that arch/arm pattern coverage is poor.  _No_
arch/arm maintainer has made any effort to better describe
the files as it's a fairly difficult job.  And I'm not the
arch/arm maintainer.

Mark Brown said: http://lkml.org/lkml/2010/9/10/116
----------------------------------------------------
On Fri, Sep 10, 2010 at 03:04:26AM -0700, Joe Perches wrote:

> It'd be great if the ARM/embedded folk would spend
> some effort improving the MAINTAINERS file pattern
> coverage.

Half the problem is that a lot of drivers aren't maintained by the
people who wrote them - for example, they wrote the driver to get a
board working but have no ongoing interest or can only really comment on
the one specific configuration used on their particular hardware.  This
means getting people to add MAINTAINERS entries is a bit more tricky
than it needs to be, even if they could offer useful review on changes.
---------------------------------------------------

So for Mark's case, the current behavior works reasonably well.

Tell me something Ted.  Have you in the last 5 years or
so done any work in the kernel outside of fs or modified
files outside of fs when fs structures weren't changed?

Are you representative of the typical user of a script like
get_maintainer or checkpatch?  Does it matter that much?

If you want it, I have a trivial script that shows the files
in the kernel that do not have an "exact pattern match"
in MAINTAINERS.  You could make the effort to find out
if those files should have pattern entries made.   I did
a lot of that privately and found out that most people
appear not to care.




Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757621Ab2FQREw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 13:04:52 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:42258 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757585Ab2FQREv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 13:04:51 -0400
Date: Sun, 17 Jun 2012 18:04:43 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <greg@kroah.com>, ksummit-2012-discuss@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Ksummit-2012-discuss] [ATTEND or not ATTEND] That's the
 question!
Message-ID: <20120617170442.GA10241@sirena.org.uk>
References: <alpine.LFD.2.02.1206152313310.3086@ionos>
 <20120615233413.GB8894@kroah.com>
 <20120616123032.251dd101@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120616123032.251dd101@pyramind.ukuu.org.uk>
X-Cookie: "But I don't like Spam!!!!"
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 16, 2012 at 12:30:32PM +0100, Alan Cox wrote:
> Greg KH <greg@kroah.com> wrote:

> We also have a large consumer electronics and now android ecosystem much
> of which is made up of companies and people whose business history and
> business model for all products has always been

> - make it boot
> - make it usable
> - ship it
> - run 

> they have little incentive to share, they have no interest in the longer
> term, and it's often not rational economics for them to clean up their
> code and upstream it because it just helps their rivals, and besides the
> part is now 6 months old so obsolete in their world.

This is actually getting a lot better these days.

> For a lot of hardware the only way that is going to get fixed is if

> a) it is easier to do the job right than hack it up
> b) when the hardware vendors are more involved and have longer term plans
> c) their customers start to demand it in order to be up and running very
> fast (ie there is heavy consolidation in the platform)

The latter two are happening right now, mostly thanks to consumer demand
for software updates for things like phones though the desire to keep
hardware platforms rolling indepenently of OS releases is also a factor.
One of the big blockers to that has been the need to move all the out of
tree stuff up to a newer kernel, reducing the diff to mainline is a good
way to minimise the effort involved.  I was very pleased when I started
to find handset vendors wanting to confirm that patches given to them
were also going upstream.

This doesn't apply to all hardware but more and more things are getting
in field updates.

> Right now we are doing it for real in some areas, and via the "screw
> this, mail Andrew Morton" process for others, plus Linus fields some of
> the really dumb ones. We could formalise some of that a bit more and
> encourage more maintainers to actual team up with one of the other
> contributors they trust.

Yes, this would really help as would better backup plans when things
aren't working.  Finding people to work with is not just a question of
trust, it's also a question of finding people with similar work patterns
as a mismatch can be painful.

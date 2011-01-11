Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932245Ab1AKOdq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 09:33:46 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:59037 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755804Ab1AKOdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 09:33:42 -0500
Date: Tue, 11 Jan 2011 15:33:25 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Ted Ts'o" <tytso@mit.edu>, david@lang.hm,
        Anca Emanuel <anca.emanuel@gmail.com>, Greg KH <greg@kroah.com>,
        Elvis Dowson <elvis.dowson@mac.com>,
        Janakiram Sistla <janakiram.sistla@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        swetland@google.com
Subject: Re: Forked android kernel development from linux kernel mainline
Message-ID: <20110111143325.GA22390@atrey.karlin.mff.cuni.cz>
References: <01784A8B-36A0-4E8A-9729-23C2B19351F8@mac.com> <20101107000348.GF2935@thunk.org> <20101110135458.GB1553@ucw.cz> <201011102138.22213.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201011102138.22213.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > What, people can't delete a couple of single lines of code before
> > > submitting the device driver upstream to mainline?  Here's the world's
> > > tiniest violin playing, "my heart bleeds for you"....
> > 
> > Deleting couple single liners is not a problem. Cleaning up 100KLoC
> > patch for mainline *is* a problem.
> > 
> > I know, I tried to do that work. Even getting it to staging quality
> > was hard, and it was recently dropped due to security holes.
> > 
> > Unfortunately google uses wakelocks as an excuse for not cleaning up
> > stuff... "because readding those few lines would be too hard".
> 
> Actually, this isn't a good excuse any more as of 2.6.37-rc1.  You can
> basically replace wakelocks with wakeup sources and go ahead.

It would be nice if someone from android comment could comment on
this. 2.6.37 is out, and it should have all the support to solve
problems also solved by wakelocks...
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916Ab0EVRdM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 13:33:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58675 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753819Ab0EVRdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 13:33:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Regression] Negative time on Acer Ferrari One with current -git
Date: Sat, 22 May 2010 19:34:09 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rjw; KDE/4.3.5; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       John Stultz <johnstul@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <201005212343.25184.rjw@sisk.pl> <alpine.LFD.2.00.1005221429360.3368@localhost.localdomain> <alpine.LFD.2.00.1005221616310.3368@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1005221616310.3368@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005221934.09705.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 22 May 2010, Thomas Gleixner wrote:
> On Sat, 22 May 2010, Thomas Gleixner wrote:
> > On Fri, 21 May 2010, Linus Torvalds wrote:
> > > On Fri, 21 May 2010, Rafael J. Wysocki wrote:
> > > > 
> > > > Trying to boot current -git on Acer Ferrari One (64-bit), I get mount errors
> > > > for all filesystems telling me that "now = (null) is in the future" and when
> > > > run 'date' it says: "date: time <long negative number> is out of range".
> > > > 
> > > > Any ideas anyone?
> > > 
> > > No ideas, but apart from the obvious "maybe you can pin it down a bit with 
> > > a few bisection compiles", it's almost certainly through the timer tree 
> > > merge from Thomas, which included various wall-clock-time changes from 
> > > John Stultz & co.
> > > 
> > > I don't see anything else that would likely affect any wall-clock time, 
> > > but who knows..
> > > 
> > > John, Thomas? Ring any bells?
> > 
> > Went through the pile and nothing stands out.
> > 
> > The system has an AMD X2 with the jinxed C1E, so I'd rather suspect
> > that we managed to break C1E again.
> > 
> > Just tried to boot -git on my X2 machine and it does not come
> > up. Investigating.
> 
> Second boot worked, I love heisenbugs. :(
> 
> Rafael, can you check whether the C1E idle is selected.

Can you please remind me how I can check that?

> Also which clocksource is used ?

hpet

Thanks,
Rafael

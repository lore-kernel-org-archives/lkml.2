Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757334Ab0EVRxA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 13:53:00 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58709 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756017Ab0EVRw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 13:52:58 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: john stultz <johnstul@us.ibm.com>
Subject: Re: [Regression] Negative time on Acer Ferrari One with current -git
Date: Sat, 22 May 2010 19:54:05 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rjw; KDE/4.3.5; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <201005212343.25184.rjw@sisk.pl> <alpine.LFD.2.00.1005211515460.3689@i5.linux-foundation.org> <1274481551.5630.31.camel@localhost.localdomain>
In-Reply-To: <1274481551.5630.31.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201005221954.05606.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 22 May 2010, john stultz wrote:
> On Fri, 2010-05-21 at 15:19 -0700, Linus Torvalds wrote:
> > 
> > On Fri, 21 May 2010, Rafael J. Wysocki wrote:
> > > 
> > > Trying to boot current -git on Acer Ferrari One (64-bit), I get mount errors
> > > for all filesystems telling me that "now = (null) is in the future" and when
> > > run 'date' it says: "date: time <long negative number> is out of range".
> > > 
> > > Any ideas anyone?
> > 
> > No ideas, but apart from the obvious "maybe you can pin it down a bit with 
> > a few bisection compiles", it's almost certainly through the timer tree 
> > merge from Thomas, which included various wall-clock-time changes from 
> > John Stultz & co.
> > 
> > I don't see anything else that would likely affect any wall-clock time, 
> > but who knows..
> > 
> > John, Thomas? Ring any bells?
> 
> Hrm..  From my queue, I'd probably try reverting the following first:
> 
> 6a867a3|| time: Remove xtime_cache

That doesn't help.
 
> Rafael: I assume 2.6.34 is fine?

Yes, it is.

Thanks,
Rafael

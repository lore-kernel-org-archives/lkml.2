Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758767Ab0EUWjW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 18:39:22 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:34697 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758717Ab0EUWjU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 18:39:20 -0400
Subject: Re: [Regression] Negative time on Acer Ferrari One with current
 -git
From: john stultz <johnstul@us.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1005211515460.3689@i5.linux-foundation.org>
References: <201005212343.25184.rjw@sisk.pl>
	 <alpine.LFD.2.00.1005211515460.3689@i5.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 21 May 2010 15:39:11 -0700
Message-ID: <1274481551.5630.31.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-21 at 15:19 -0700, Linus Torvalds wrote:
> 
> On Fri, 21 May 2010, Rafael J. Wysocki wrote:
> > 
> > Trying to boot current -git on Acer Ferrari One (64-bit), I get mount errors
> > for all filesystems telling me that "now = (null) is in the future" and when
> > run 'date' it says: "date: time <long negative number> is out of range".
> > 
> > Any ideas anyone?
> 
> No ideas, but apart from the obvious "maybe you can pin it down a bit with 
> a few bisection compiles", it's almost certainly through the timer tree 
> merge from Thomas, which included various wall-clock-time changes from 
> John Stultz & co.
> 
> I don't see anything else that would likely affect any wall-clock time, 
> but who knows..
> 
> John, Thomas? Ring any bells?

Hrm..  From my queue, I'd probably try reverting the following first:

6a867a3|| time: Remove xtime_cache

Rafael: I assume 2.6.34 is fine?

thanks
-john



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758733Ab0EUWWb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 18:22:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44184 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758612Ab0EUWWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 18:22:30 -0400
Date: Fri, 21 May 2010 15:19:46 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, John Stultz <johnstul@us.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Regression] Negative time on Acer Ferrari One with current
 -git
In-Reply-To: <201005212343.25184.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.1005211515460.3689@i5.linux-foundation.org>
References: <201005212343.25184.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 21 May 2010, Rafael J. Wysocki wrote:
> 
> Trying to boot current -git on Acer Ferrari One (64-bit), I get mount errors
> for all filesystems telling me that "now = (null) is in the future" and when
> run 'date' it says: "date: time <long negative number> is out of range".
> 
> Any ideas anyone?

No ideas, but apart from the obvious "maybe you can pin it down a bit with 
a few bisection compiles", it's almost certainly through the timer tree 
merge from Thomas, which included various wall-clock-time changes from 
John Stultz & co.

I don't see anything else that would likely affect any wall-clock time, 
but who knows..

John, Thomas? Ring any bells?

		Linus

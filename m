Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250Ab0KRJtM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 04:49:12 -0500
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:37333 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686Ab0KRJtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 04:49:10 -0500
Date: Thu, 18 Nov 2010 11:49:08 +0200
From: Alexander Shishkin <virtuoso@slind.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Davide Libenzi <davidel@xmailserver.org>,
        Kyle Moffett <kyle@moffetthome.net>, Valdis.Kletnieks@vt.edu,
        LKML <linux-kernel@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Kay Sievers <kay.sievers@vrfy.org>,
        Greg KH <gregkh@suse.de>, Chris Friesen <chris.friesen@genband.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCHv6 0/7] system time changes notification
Message-ID: <20101118094908.GE26184@shisha.kicks-ass.net>
References: <1289503802-22444-1-git-send-email-virtuoso@slind.org>
 <22542.1289507293@localhost>
 <20101111205123.GC10585@shisha.kicks-ass.net>
 <alpine.LFD.2.00.1011112212460.2900@localhost6.localdomain6>
 <AANLkTik8FS5p_P_2ygh9qC2qg7wTDP+23LKbhJCKcMez@mail.gmail.com>
 <alpine.LFD.2.00.1011112322280.2900@localhost6.localdomain6>
 <20101117190659.GB26184@shisha.kicks-ass.net>
 <alpine.DEB.2.00.1011171130210.1595@davide-lnx1>
 <20101117212912.GC26184@shisha.kicks-ass.net>
 <alpine.LFD.2.00.1011172244470.2900@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1011172244470.2900@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 10:46:48PM +0100, Thomas Gleixner wrote:
> On Wed, 17 Nov 2010, Alexander Shishkin wrote:
> 
> > On Wed, Nov 17, 2010 at 12:42:52PM -0800, Davide Libenzi wrote:
> > > On Wed, 17 Nov 2010, Alexander Shishkin wrote:
> > > 
> > > > > But what you folks really want for this stuff is an extension to
> > > > > timerfd as you want to be able to poll, right?
> > > > > 
> > > > > So what about the following:
> > > > > 
> > > > > Add a new flag TDF_NOTIFY_CLOCK_WAS_SET to the timerfd flags. Now this
> > > > > flag adds the timer to a separate list, which gets woken up when the
> > > > > clock is set.
> > > > > 
> > > > > No new syscall, just a few lines of code in fs/timerfd.c and
> > > > > clock_was_set().
> > > > > 
> > > > > Thoughts ?
> > > > 
> > > > Something like this (sans ugliness)?
> > > 
> > > Oh, gosh, please.  This is interface-multiplexing-a-palooza.
> > 
> > Thomas made a suggestion, I came up with how it might look like so that
> 
> Yeah, I made the suggestion in the first place and I regretted it when
> Davide told me that I'm nuts :)

Well, I haven't seen any convincing technical arguments in either of
his emails. Kay, for example, made a clear point.

Regards,
--
Alex

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757187Ab0KRNIs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 08:08:48 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47134 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944Ab0KRNIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 08:08:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=UzBzoSRjb3uuHE6fKdPc4SbM9FCyfXolGfTE7qV6b6xa466MLzueJgnlSUufDt/tC2
         tYtJ0FCTeynxrtGoaZ+hu7gEXubYHOuLScuDHED1z5HLjcLbASB+yixMx1Leu27hgi7G
         idK2ltDBoJEJw56CK43ebjgg8k9i4Pf35ZPF0=
Subject: Re: [PATCHv6 0/7] system time changes notification
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Alexander Shishkin <virtuoso@slind.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kyle Moffett <kyle@moffetthome.net>, Valdis.Kletnieks@vt.edu,
        LKML <linux-kernel@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Kay Sievers <kay.sievers@vrfy.org>,
        Greg KH <gregkh@suse.de>, Chris Friesen <chris.friesen@genband.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
In-Reply-To: <alpine.DEB.2.00.1011171130210.1595@davide-lnx1>
References: <1289503802-22444-1-git-send-email-virtuoso@slind.org>
	 <22542.1289507293@localhost> <20101111205123.GC10585@shisha.kicks-ass.net>
	 <alpine.LFD.2.00.1011112212460.2900@localhost6.localdomain6>
	 <AANLkTik8FS5p_P_2ygh9qC2qg7wTDP+23LKbhJCKcMez@mail.gmail.com>
	 <alpine.LFD.2.00.1011112322280.2900@localhost6.localdomain6>
	 <20101117190659.GB26184@shisha.kicks-ass.net>
	 <alpine.DEB.2.00.1011171130210.1595@davide-lnx1>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Nov 2010 15:08:20 +0200
Message-ID: <1290085700.2270.7.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.0 (2.32.0-2.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-17 at 12:42 -0800, Davide Libenzi wrote:
> On Wed, 17 Nov 2010, Alexander Shishkin wrote:
> 
> > > But what you folks really want for this stuff is an extension to
> > > timerfd as you want to be able to poll, right?
> > > 
> > > So what about the following:
> > > 
> > > Add a new flag TDF_NOTIFY_CLOCK_WAS_SET to the timerfd flags. Now this
> > > flag adds the timer to a separate list, which gets woken up when the
> > > clock is set.
> > > 
> > > No new syscall, just a few lines of code in fs/timerfd.c and
> > > clock_was_set().
> > > 
> > > Thoughts ?
> > 
> > Something like this (sans ugliness)?
> 
> Oh, gosh, please.  This is interface-multiplexing-a-palooza.
> It should be decided if the feature makes sense, and then have proper 
> interface, instead of multiplexing unrelated insterfaces.
> This is a sort of system-event-report pattern.  What is wrong with using a 
> netlink-based transport for those kind of things?

Could you please explain in more details what is the problem?

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)


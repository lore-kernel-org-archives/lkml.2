Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756808Ab1FQHLW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 03:11:22 -0400
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:38129 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751334Ab1FQHLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 03:11:20 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAHz8+k1tg4yN/2dsb2JhbABSpmt4iHMCwDEOhhkEoV0
Date: Fri, 17 Jun 2011 09:11:18 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Andrea Galbusera <gizero@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC] [PATCH 0/10] Generic Watchdog Timer Driver
Message-ID: <20110617071118.GJ23305@infomag.iguana.be>
References: <20110223204108.GA6327@infomag.iguana.be> <BANLkTimM+9__P4jpvuEL0zDFCyzPX=MrmA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTimM+9__P4jpvuEL0zDFCyzPX=MrmA@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrea,

> On Wed, Feb 23, 2011 at 9:41 PM, Wim Van Sebroeck <wim@iguana.be> wrote:
> > To reduce copying the same code over and over in each watchdog device driver, Alan Cox and myself constructed a new framework/API that consolidates the common watchdog timer driver functions.
> >
> > This framework/API consists of the following patches:
> > part  1: Introduction of the WatchDog Timer Driver Core
> > part  2: Add the basic ioctl functionality
> > part  3: Add the WDIOC_KEEPALIVE ioctl
> > part  4: Add the WDIOC_SETOPTIONS ioctl
> > part  5: Add the WDIOC_SETTIMEOUT and WDIOC_GETTIMEOUT ioctl
> > part  6: Add orphan control
> > part  7: Add the Magic Close feature
> > part  8: Add the nowayout feature
> > part  9: Add support for a miscdev parent device
> > part 10: Add support for extra ioctl calls
> 
> While looking for efforts to provide a generic driver for gpio driven
> watchdog devices, like some simple hardware supervisors, I came into
> this patchset RFC, which turned out to be very interesting to me.
> Maybe I'm looking into the wrong places, but I could not find any
> upstream commit after this RFC.
> Since I don't see any real critic from commenters to the approach you
> are suggesting, I'd like to know if there still is some
> work-in-progress on this.

I was working on it yesterday and will finish testing today.
So expect a new post this afternoon.

I incorporated the comments I received. Orphan control will not be in (as
long as the watchdog device is registered you can reopen it). And we will
add the minimum and maximum timeout in an extra part.

Kind regards,
Wim.


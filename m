Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758168Ab0HJXxn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 19:53:43 -0400
Received: from cantor.suse.de ([195.135.220.2]:46147 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757854Ab0HJXxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 19:53:38 -0400
Date: Tue, 10 Aug 2010 16:53:23 -0700
From: Greg KH <gregkh@suse.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Patrick Pannuto <ppannuto@quicinc.com>,
        Patrick Pannuto <ppannuto@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "damm@opensource.se" <damm@opensource.se>,
        "lethal@linux-sh.org" <lethal@linux-sh.org>,
        "rjw@sisk.pl" <rjw@sisk.pl>, "dtor@mail.ru" <dtor@mail.ru>,
        "eric.y.miao@gmail.com" <eric.y.miao@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Kevin Hilman <khilman@deeprootsystems.com>
Subject: Re: [RFC PATCH] platform: Faciliatate the creation of
 pseduo-platform busses
Message-ID: <20100810235323.GA24612@suse.de>
References: <20100803235631.GA17759@suse.de>
 <4C58AE15.6090900@codeaurora.org>
 <20100804000945.GA19729@suse.de>
 <4C58B1B6.9050005@quicinc.com>
 <AANLkTikVzh9=DvvUPbKmDeo6k2-pPVSnjH+GxAPdQFO4@mail.gmail.com>
 <20100806142727.GB4921@suse.de>
 <AANLkTi=VbVed09=u-Ea0L8c_CWZ_CLLjWH9ZjD2dyg6Y@mail.gmail.com>
 <20100806234635.GC16793@suse.de>
 <AANLkTimHbcF+fz=aBMLdhLo2s-rhfNvaPCtqE8nYJ8aT@mail.gmail.com>
 <AANLkTimjXd=SL61KvjDfvJ-JtXsSVW9pwOYBFUHX0mVp@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimjXd=SL61KvjDfvJ-JtXsSVW9pwOYBFUHX0mVp@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 07, 2010 at 11:28:13AM -0600, Grant Likely wrote:
> On Sat, Aug 7, 2010 at 12:35 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
> > On Fri, Aug 6, 2010 at 5:46 PM, Greg KH <gregkh@suse.de> wrote:
> >> That would be nice, but take your "standard" PC today:
> >>        > ls /sys/devices/platform/
> >>        Fixed MDIO bus.0  i8042  pcspkr  power  serial8250  uevent vesafb.0
> >>
> >> There are tty devices below the serial port, which is nice to see, but
> >> the others?  I don't know what type of bus they would be on, do you?
> [...]
> > I wouldn't have any problem modifying those specific drivers to
> > register under something like /sys/devices/legacy, but I don't really
> > think it is in any way necessary.
> 
> Or for that matter, make those drivers explicitly use
> /sys/devices/platform so that I don't cause churn on PCs.  :-)  I'd
> like to be rid of it as default behaviour for embedded though.

Yes, that would be the easier (and better) solution.

thanks,

greg k-h

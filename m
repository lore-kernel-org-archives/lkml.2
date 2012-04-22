Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317Ab2DVQe0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 12:34:26 -0400
Received: from smtp.tele.fi ([192.89.123.25]:33291 "EHLO smtp.tele.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751441Ab2DVQeZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 12:34:25 -0400
X-Originating-Ip: [194.89.68.22]
Date: Sun, 22 Apr 2012 19:34:18 +0300
From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
To: Lars Boegild Thomsen <lth@cow.dk>
Cc: Jonathan Nieder <jrnieder@gmail.com>, Kevin Tian <kevin.tian@intel.com>,
        xen-devel@lists.xensource.com, Robert Scott <bugs@humanleg.org.uk>,
        hpa@zytor.com, linux-kernel@vger.kernel.org,
        Ian Campbell <Ian.Campbell@eu.citrix.com>, mingo@redhat.com,
        Fengzhe Zhang <fengzhe.zhang@intel.com>,
        e568b31a443d@6cc2cce7af2d.anonbox.net,
        Thomas Gleixner <tglx@linutronix.de>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>
Subject: Re: [Xen-devel] [regression] Ideapad S10-3 does not wake up from
 suspend
Message-ID: <20120422163418.GD2058@reaktio.net>
References: <625BA99ED14B2D499DC4E29D8138F1505C8ED7F7E3@shsmsx502.ccr.corp.intel.com>
 <201204161905.13260.bugs@humanleg.org.uk>
 <20120417020433.GA15848@burratino>
 <201204181803.00383.lth@cow.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201204181803.00383.lth@cow.dk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 06:03:00PM +0800, Lars Boegild Thomsen wrote:
> On Tuesday 17 April 2012 10:04:33 Jonathan Nieder wrote:
> > > Hmm, no, 3.4-rc2 seems to produce the same results I'm afraid.
> > Alas.  Does suspend-to-disk ("echo disk >/sys/power/state") have the
> > same problem?  Can you get a log of the failure with
> > "no_console_suspend" appended to the kernel command line, for example
> > with a serial console or netconsole?
> 
> Using a serial console is a bit of a problem on this netbook as it hasn't got 
> a serial port.  Not sure how the netconsole works - will read up on that.
> 

You can get an ExpressCard Serial Card and use that..
or if the laptop has vPro then it has Serial Over LAN in the AMT chip.

http://wiki.xen.org/wiki/Xen_Serial_Console

-- Pasi

> And no - suspend to disk works fine.
> 
> I have by the way experimentally switched to 32bit version and it's the same 
> thing (originally I was running 64bit version but that really doesn't make 
> sense on a netbook - except doing it because it could be done).
> 
> //Lars...
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel

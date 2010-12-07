Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180Ab0LGAQh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 19:16:37 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41174 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753015Ab0LGAQg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 19:16:36 -0500
Date: Mon, 6 Dec 2010 16:15:10 -0800
From: Greg KH <gregkh@suse.de>
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Cc: Greg KH <greg@kroah.com>, Alan Cox <alan@linux.intel.com>,
        linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Mike Frysinger <vapier@gentoo.org>,
        Feng Tang <feng.tang@intel.com>, Tobias Klauser <tklauser@distanz.ch>,
        yong.y.wang@intel.com, qi.wang@intel.com, kok.howg.ewe@intel.com,
        andrew.chih.howe.khor@intel.com
Subject: Re: Serial: EG20T: add PCH_UART driver
Message-ID: <20101207001510.GA28176@suse.de>
References: <4CE3281A.4050709@dsn.okisemi.com>
 <20101201012441.GA2907@kroah.com>
 <F707E6EFF9AF4169B5E0C55B5AB2757B@hacdom.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F707E6EFF9AF4169B5E0C55B5AB2757B@hacdom.okisemi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 07, 2010 at 09:05:34AM +0900, Tomoya MORINAGA wrote:
> On Wednesday, December 01, 2010 10:24 AM, Greg KH wrote:
> >I've applied this, but I now get the following warnings when building
> >the code:
> 
> Sorry, for late.
> I can't see these warnings.
> I think we build with 32bit Linux PC.
> But we don't have 64-bit PC.
> 
> I tried build with "-m64" option on our PC, I can see the following error.
> : sorry, unimplemented: 64-bit mode not compiled in
> 
> Can I see the warnings using our PC ?
> If you have any information, let me know how to do.

Yes, use a version of gcc that will build in 64bit mode :)

Or use a modern processor (I find it hard to believe you don't have
access to a 64bit intel processor these days...)

thanks,

greg k-h

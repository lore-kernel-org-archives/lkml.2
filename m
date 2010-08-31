Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757381Ab0HaNcj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 09:32:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35512 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753042Ab0HaNci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 09:32:38 -0400
Date: Tue, 31 Aug 2010 06:32:01 -0700
From: Greg KH <gregkh@suse.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Rogier Wolff <R.E.Wolff@bitwizard.nl>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Mike Frysinger <vapier.adi@gmail.com>,
        "Michael H. Warfield" <mhw@wittsend.com>
Subject: Re: [RFC 0/5] tty: move stuff around
Message-ID: <20100831133201.GB2429@suse.de>
References: <1283115995-4734-1-git-send-email-arnd@arndb.de>
 <201008311126.45190.arnd@arndb.de>
 <20100831104205.GA2301@bitwizard.nl>
 <201008311354.47275.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201008311354.47275.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 31, 2010 at 01:54:47PM +0200, Arnd Bergmann wrote:
> On Tuesday 31 August 2010, Rogier Wolff wrote:
> > The question is whether I want the drivers I wrote to stay or to
> > go away?
> 
> More or less, yes.
>  
> > I was paid years ago to make Linux support the Specialix cards. It
> > started with one card from their line of "solutions", but the others
> > followed.
> 
> The most important question is whether you think that there are people
> somewhere in the world that are using the device drivers on machines
> with recent kernels.
> 
> If you still get bug reports for the drivers, that would be a clear
> indication to make them stay, while if you haven't heard from a user
> during the last five years, it's probably obsolete enough that it
> can be removed (after a few kernels of grace period in drivers/staging).

And it is always possible to revert a removal at a later time and fix up
a driver if someone does show up in a few years asking where the driver
went.

thanks,

greg k-h

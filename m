Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485Ab0ICW4Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 18:56:24 -0400
Received: from cantor.suse.de ([195.135.220.2]:48420 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752362Ab0ICW4L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 18:56:11 -0400
Date: Fri, 3 Sep 2010 15:46:06 -0700
From: Greg KH <gregkh@suse.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jiri Slaby <jslaby@suse.cz>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org, Rogier Wolff <R.E.Wolff@bitwizard.nl>,
        "Michael H. Warfield" <mhw@wittsend.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [RFC 0/5] tty: move stuff around
Message-ID: <20100903224606.GA12229@suse.de>
References: <1283115995-4734-1-git-send-email-arnd@arndb.de>
 <201009031729.58102.arnd@arndb.de>
 <20100903165522.GB26271@suse.de>
 <201009031942.46289.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201009031942.46289.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 03, 2010 at 07:42:46PM +0200, Arnd Bergmann wrote:
> On Friday 03 September 2010, Greg KH wrote:
> > As this is just a lot of code movement, it probably makes more sense for
> > me to do this myself, right?
> 
> Depends on whether you want a git tree or full patches for this.
> I'd prefer not doing it myself, if you already offer to do it.
> 
> I guess the hardest part is splitting the Makefile and Kconfig
> files appropriately. I've done that mostly for the first version,
> so you should probably start from there and move it around some
> more, splitting out the staging parts.

Ok, I'll do it this weekend.  I have a 12 hour plane ride so I need
something to do on it...

thanks,

greg k-h

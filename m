Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756721Ab0ICQzi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 12:55:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48925 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756682Ab0ICQzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 12:55:37 -0400
Date: Fri, 3 Sep 2010 09:55:22 -0700
From: Greg KH <gregkh@suse.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jiri Slaby <jslaby@suse.cz>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org, Rogier Wolff <R.E.Wolff@bitwizard.nl>,
        "Michael H. Warfield" <mhw@wittsend.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [RFC 0/5] tty: move stuff around
Message-ID: <20100903165522.GB26271@suse.de>
References: <1283115995-4734-1-git-send-email-arnd@arndb.de>
 <20100830184737.GA21339@suse.de>
 <201008302333.22447.arnd@arndb.de>
 <201009031729.58102.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201009031729.58102.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 03, 2010 at 05:29:57PM +0200, Arnd Bergmann wrote:
> This is the updated list, I hope I captured all the comments correctly:
>  
> drivers/char/tty_*      -> tty/*
> drivers/char/{vt stuff} -> tty/vt/
> 
> drivers/char/hvc_*      -> drivers/tty/hvc/hvc_*
> drivers/serial/*        -> drivers/tty/serial/*
> drivers/usb/serial      -> drivers/usb/serial
> 
> amiserial,nozomi,synclink,
> rocket,ipwireless
> cyclades,moxa,mxser,
> isicom,bfin_jtag_comm   -> drivers/tty/
> 
> stallion,istallion,
> epca,specialix,ip2,
> riscom,serial167	-> drivers/staging/tty/*
>  
> generic_serial,vme_scc,
> ser_a2232,sx,rio        -> drivers/staging/generic_serial/*

Looks correct to me.  The staging ones will be "depreciated" and will
age out over 2 kernel releases unless someone objects.

As this is just a lot of code movement, it probably makes more sense for
me to do this myself, right?

thanks for getting all of this together.

greg k-h

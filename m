Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755654Ab1BWBOH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 20:14:07 -0500
Received: from kroah.org ([198.145.64.141]:37935 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755259Ab1BWBOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 20:14:05 -0500
Date: Tue, 22 Feb 2011 17:12:23 -0800
From: Greg KH <greg@kroah.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg KH <gregkh@suse.de>, Jiri Slaby <jslaby@suse.cz>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        Rogier Wolff <R.E.Wolff@bitwizard.nl>,
        "Michael H. Warfield" <mhw@wittsend.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [RFC 0/5] tty: move stuff around
Message-ID: <20110223011223.GA5690@kroah.com>
References: <1283115995-4734-1-git-send-email-arnd@arndb.de>
 <20100830184737.GA21339@suse.de>
 <201008302333.22447.arnd@arndb.de>
 <201009031729.58102.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201009031729.58102.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
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

Ok, I've now moved the rest of these files in the tty-next tree, so we
should be completed with this for .39.

If there are any problems, or I missed any files, please let me know.

thanks,

greg k-h

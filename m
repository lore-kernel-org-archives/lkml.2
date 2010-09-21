Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181Ab0IUXIg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 19:08:36 -0400
Received: from kroah.org ([198.145.64.141]:34989 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751484Ab0IUXIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 19:08:36 -0400
Date: Tue, 21 Sep 2010 16:07:33 -0700
From: Greg KH <greg@kroah.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg KH <gregkh@suse.de>, Jiri Slaby <jslaby@suse.cz>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        Rogier Wolff <R.E.Wolff@bitwizard.nl>,
        "Michael H. Warfield" <mhw@wittsend.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [RFC 0/5] tty: move stuff around
Message-ID: <20100921230733.GA32346@kroah.com>
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

Ok, here's 2 patches that just does these two things.

Does it look correct?  For the second patch, shoudl I really be moving
the defkeymap and keyboard and selection files as well?

thoughts?

thanks,

greg k-h

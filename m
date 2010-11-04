Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274Ab0KDWaS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 18:30:18 -0400
Received: from kroah.org ([198.145.64.141]:35658 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751849Ab0KDWaQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 18:30:16 -0400
Date: Thu, 4 Nov 2010 15:29:06 -0700
From: Greg KH <greg@kroah.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg KH <gregkh@suse.de>, Jiri Slaby <jslaby@suse.cz>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        Rogier Wolff <R.E.Wolff@bitwizard.nl>,
        "Michael H. Warfield" <mhw@wittsend.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [00/02] TTY: move the tty core to drivers/tty
Message-ID: <20101104222906.GA3390@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd and others,

Here's the latest version of the "move the tty files around" patch that
I'd like to send to Linus now that -rc1 is out and things have settled
down.  It only moves the tty core and the vt code out of drivers/char.
I'll do the movement of the serial drivers and other things that were
discussed later, for .38, but I wanted to get this move to him now as
it's easiest to do so at this point in time.

Any objections to this?

thanks,

greg k-h

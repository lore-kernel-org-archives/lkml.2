Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758685Ab2AFNmu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 08:42:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37639 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755481Ab2AFNms (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 08:42:48 -0500
Date: Fri, 6 Jan 2012 05:42:01 -0800
From: Greg KH <gregkh@suse.de>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Alan Cox <alan@linux.intel.com>, Sam Ravnborg <sam@ravnborg.org>,
        Arnd Bergmann <arnd@arndb.de>, Jiri Slaby <jslaby@suse.cz>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH] serial: relocate remaining serial drivers from tty/ to
 tty/serial/
Message-ID: <20120106134201.GD9453@suse.de>
References: <1325707287-31038-1-git-send-email-paul.gortmaker@windriver.com>
 <4F04BFA8.9010100@windriver.com>
 <20120104220332.GA22985@suse.de>
 <201201042327.33739.arnd@arndb.de>
 <20120105054240.GA9093@merkur.ravnborg.org>
 <20120105124505.73c88f2c@bob.linux.org.uk>
 <20120105232142.GA10870@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120105232142.GA10870@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 05, 2012 at 06:21:43PM -0500, Paul Gortmaker wrote:
> [Re: [PATCH] serial: relocate remaining serial drivers from tty/ to tty/serial/] On 05/01/2012 (Thu 12:45) Alan Cox wrote:
> 
> > > drivers/tty/serial_core  <= drivers based on SERIAL_CORE
> > > drivers/tty/serial       <= the rest
> > > 
> > > This makes it obvious that one directory is for drivers based on
> > > SERIAL_CORE - and the other is sort of the "rest".
> > > 
> > > I know this imply moving files around again :-(
> > 
> > And putting one lot where the other were. Merge time is closed so we've
> > got plenty of time to sort this right. For the moment can we just tidy
> > up 8250, then think about it in more detail rather than play musical
> > chairs ?
> 
> Presumably too late for 3.3, but I figured I'd send the 8250 tidy up
> for review while the discussion was still fresh in everyone's mind.

That looks good, I'll see if I can get this in after -rc1 is out as
moving files then is usually easier.

Unless anyone objects to this patch?

thanks,

greg k-h

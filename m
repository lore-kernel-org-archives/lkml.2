Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757128Ab2ADWDu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 17:03:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39783 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757111Ab2ADWDr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 17:03:47 -0500
Date: Wed, 4 Jan 2012 14:03:32 -0800
From: Greg KH <gregkh@suse.de>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Jiri Slaby <jslaby@suse.cz>, alan@linux.intel.com,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH] serial: relocate remaining serial drivers from tty/ to
 tty/serial/
Message-ID: <20120104220332.GA22985@suse.de>
References: <1325707287-31038-1-git-send-email-paul.gortmaker@windriver.com>
 <4F04B7DC.70809@suse.cz>
 <20120104205146.GA21430@suse.de>
 <4F04BFA8.9010100@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F04BFA8.9010100@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 04, 2012 at 04:07:52PM -0500, Paul Gortmaker wrote:
> On 12-01-04 03:51 PM, Greg KH wrote:
> > On Wed, Jan 04, 2012 at 09:34:36PM +0100, Jiri Slaby wrote:
> >> On 01/04/2012 09:01 PM, Paul Gortmaker wrote:
> >>>  rename drivers/tty/{ => serial}/amiserial.c (100%)
> >>>  rename drivers/tty/{ => serial}/cyclades.c (100%)
> >>>  rename drivers/tty/{ => serial}/isicom.c (100%)
> >>>  rename drivers/tty/{ => serial}/moxa.c (100%)
> >>>  rename drivers/tty/{ => serial}/moxa.h (100%)
> >>>  rename drivers/tty/{ => serial}/mxser.c (100%)
> >>>  rename drivers/tty/{ => serial}/mxser.h (100%)
> >>>  rename drivers/tty/{ => serial}/rocket.c (100%)
> >>>  rename drivers/tty/{ => serial}/rocket.h (100%)
> >>>  rename drivers/tty/{ => serial}/rocket_int.h (100%)
> >>>  rename drivers/tty/{ => serial}/synclink.c (100%)
> >>>  rename drivers/tty/{ => serial}/synclink_gt.c (100%)
> >>>  rename drivers/tty/{ => serial}/synclinkmp.c (100%)
> >>
> >> Hmm, tty/serial/* used to be for those using serial-core. And tty/ for
> >> those who don't. But FWIW I don't mind the change.
> > 
> > Yes, that is what I used when splitting them up, so this patch doesn't
> > make much sense.
> > 
> > Paul, why do you want these all mixed together?
> 
> My thinking was that having a drivers/tty/serial dir and then
> not having all the serial drivers in that dir violated the
> principle of least surprise.  Is there a reason why the dir should
> be the exclusive domain of drivers with a dependency on SERIAL_CORE?

Because that is what the directory is for?  :)

We have other "serial" like drivers all over the kernel, this was for
the SERIAL_CORE drivers only at the moment.

thanks,

greg k-h

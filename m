Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469Ab0HTQEF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 12:04:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52130 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753400Ab0HTQED (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 12:04:03 -0400
Date: Fri, 20 Aug 2010 08:39:10 -0700
From: Greg KH <gregkh@suse.de>
To: Raju Rameshwar Uprade <rajsingh@ncra.tifr.res.in>
Cc: Oliver Neukum <oneukum@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Regarding USB-Serial Device driver
Message-ID: <20100820153910.GA11608@suse.de>
References: <20100819055329.M29689@admin-gateway.ncra.tifr.res.in> <20100819061525.M24093@admin-gateway.ncra.tifr.res.in> <201008190938.44532.marek.vasut@gmail.com> <20100819141812.GA12375@suse.de> <20100820033259.M54157@admin-gateway.ncra.tifr.res.in> <20100820035632.GA7349@suse.de> <20100820064731.M31524@admin-gateway.ncra.tifr.res.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100820064731.M31524@admin-gateway.ncra.tifr.res.in>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 20, 2010 at 12:26:22PM +0530, Raju Rameshwar Uprade wrote:
> Greg,
>       Sorry for including quotations in my email.

No, that's not the point.  Please don't top-post, that's the problem.

> Oliver,
>           I see the  superfluous data with usbmon also.

Then your driver is at fault :)

> I have changed the pl2303_write(), according to my need.I enabled the RTS line before 
> the data transmission and after a delay of 5ms ,disabled the RTS lines for my MCM device
> to respond.

Again, please use a more modern kernel version, and then, please show
the exact diff (in 'diff -u' format) that you made.

thanks,

greg k-h

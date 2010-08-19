Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594Ab0HSOjq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 10:39:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35216 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752318Ab0HSOjp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 10:39:45 -0400
Date: Thu, 19 Aug 2010 07:18:12 -0700
From: Greg KH <gregkh@suse.de>
To: Marek Vasut <marek.vasut@gmail.com>
Cc: Raju Rameshwar Uprade <rajsingh@ncra.tifr.res.in>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        maxinbjohn@gmail.com, orest.bond@outpostembedded.com,
        vijaykumar@zilogic.com
Subject: Re: Regarding USB-Serial Device driver
Message-ID: <20100819141812.GA12375@suse.de>
References: <20100819055329.M29689@admin-gateway.ncra.tifr.res.in> <20100819061525.M24093@admin-gateway.ncra.tifr.res.in> <201008190938.44532.marek.vasut@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201008190938.44532.marek.vasut@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 19, 2010 at 09:38:44AM +0200, Marek Vasut wrote:
> Dne ??t 19. srpna 2010 08:17:30 Raju Rameshwar Uprade napsal(a):
> > Dear Sir,
> >          I am trying to write a Pl2303_mcm.c usb-serial device driver which
> > will be able to talk to several devices using RS-485 interface card.I have
> > modified the standard pl2303.c by which I am able to enable/disable the
> > RTS line.
> > I am sending 10 bytes of data to the device, data is going out but instead
> > of 10 bytes, device driver is sending a large amount of data as seen on
> > Lecroy waverunner oscilloscope. Here I am sending the modified file.
> 
> Hi, I have no idea why I'm CCed in this, but anyway.
> 
> 1) could you please update the driver to a more recent kernel (we are 10 kernel 
> versions further now)
> 2) could you please send a diff instead of a whole file? (git diff <file1> 
> <file2> > diff.diff ... see man git-diff)

Yes, Raju, please see the file, Documentation/SubmittingPatches for how
to do this properly.

Also, does your updated driver work properly for you?  It would be good
to have proper RTS support in the pl2303 driver, but I thought that the
driver already supported this?

thanks,

greg k-h

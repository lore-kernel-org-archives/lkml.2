Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757423Ab0IUABg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 20:01:36 -0400
Received: from kroah.org ([198.145.64.141]:39194 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757266Ab0IUABf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 20:01:35 -0400
Date: Mon, 20 Sep 2010 17:00:20 -0700
From: Greg KH <greg@kroah.com>
To: Maurice Dawson <mauricedawson2699@gmail.com>
Cc: gregkh@suse.de, arun.thomas@gmail.com, stewart_r@aliencamel.com,
        u.kleine-koenig@pengutronix.de, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] Staging: comedi: fix space coding style issue in
 ni_labpc.c
Message-ID: <20100921000020.GD8063@kroah.com>
References: <1284919941-1997-1-git-send-email-mauricedawson2699@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284919941-1997-1-git-send-email-mauricedawson2699@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 19, 2010 at 07:12:21PM +0100, Maurice Dawson wrote:
> This is a patch to the ni_labpc.c file that fixes up multiple please,
> no space for starting a line warnings, found by the checkpatch.pl tool
> 
> Signed-off-by: Maurice Dawson <mauricedawson2699@gmail.com>
> ---
>  drivers/staging/comedi/drivers/ni_labpc.c |   40 ++++++++++++++--------------
>  1 files changed, 20 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/staging/comedi/drivers/ni_labpc.c b/drivers/staging/comedi/drivers/ni_labpc.c
> index 3acf7e6..8d120cd 100644
> --- a/drivers/staging/comedi/drivers/ni_labpc.c
> +++ b/drivers/staging/comedi/drivers/ni_labpc.c
> @@ -1,21 +1,21 @@
>  /*
> -    comedi/drivers/ni_labpc.c
> -    Driver for National Instruments Lab-PC series boards and compatibles
> -    Copyright (C) 2001, 2002, 2003 Frank Mori Hess <fmhess@users.sourceforge.net>
> +comedi/drivers/ni_labpc.c
> +Driver for National Instruments Lab-PC series boards and compatibles
> +Copyright (C) 2001, 2002, 2003 Frank Mori Hess <fmhess@users.sourceforge.net>
>  
> -    This program is free software; you can redistribute it and/or modify
> -    it under the terms of the GNU General Public License as published by
> -    the Free Software Foundation; either version 2 of the License, or
> -    (at your option) any later version.
> +This program is free software; you can redistribute it and/or modify
> +it under the terms of the GNU General Public License as published by
> +the Free Software Foundation; either version 2 of the License, or
> +(at your option) any later version.
>  
> -    This program is distributed in the hope that it will be useful,
> -    but WITHOUT ANY WARRANTY; without even the implied warranty of
> -    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> -    GNU General Public License for more details.
> +This program is distributed in the hope that it will be useful,
> +but WITHOUT ANY WARRANTY; without even the implied warranty of
> +MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +GNU General Public License for more details.
>  
> -    You should have received a copy of the GNU General Public License
> -    along with this program; if not, write to the Free Software
> -    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> +You should have received a copy of the GNU General Public License
> +along with this program; if not, write to the Free Software
> +Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>  
>  ************************************************************************
>  */
> @@ -24,7 +24,7 @@ Driver: ni_labpc
>  Description: National Instruments Lab-PC (& compatibles)
>  Author: Frank Mori Hess <fmhess@users.sourceforge.net>
>  Devices: [National Instruments] Lab-PC-1200 (labpc-1200),
> -  Lab-PC-1200AI (labpc-1200ai), Lab-PC+ (lab-pc+), PCI-1200 (ni_labpc)
> +	Lab-PC-1200AI(labpc-1200ai), Lab-PC + (lab-pc+), PCI-1200 (ni_labpc)

Why drop the ' 's ?

>  Status: works
>  
>  Tested with lab-pc-1200.  For the older Lab-PC+, not all input ranges
> @@ -47,13 +47,13 @@ from the eeprom and store them into a file that can be then be used by
>  comedilib, use the comedi_calibrate program.
>  
>  Configuration options - ISA boards:
> -  [0] - I/O port base address
> -  [1] - IRQ (optional, required for timed or externally triggered conversions)
> -  [2] - DMA channel (optional)
> +[0] - I/O port base address
> +[1] - IRQ(optional, required for timed or externally triggered conversions)
> +[2] - DMA channel(optional)

same here?  Why make that change?  Heck, these lines shouldn't be
changed at all anyway, right?

thanks,

greg k-h

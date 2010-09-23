Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756274Ab0IWTSv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 15:18:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42732 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756160Ab0IWTSt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 15:18:49 -0400
Date: Thu, 23 Sep 2010 12:10:34 -0700
From: Greg KH <gregkh@suse.de>
To: Maurice Dawson <mauricedawson2699@gmail.com>
Cc: arun.thomas@gmail.com, stewart_r@aliencamel.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/12] Staging: comedi: fix space coding style issue in
 ni_labpc.c
Message-ID: <20100923191034.GA21887@suse.de>
References: <1285268021-2020-1-git-send-email-mauricedawson2699@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285268021-2020-1-git-send-email-mauricedawson2699@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 23, 2010 at 07:53:41PM +0100, Maurice Dawson wrote:
> This is a patch to the ni_labpc.c file that fixes up multiple please,
> no space for starting a line warnings, found by the checkpatch.pl tool
> 
> Signed-off-by: Maurice Dawson <mauricedawson2699@gmail.com>
> ---
>  drivers/staging/comedi/drivers/ni_labpc.c |   40 ++++++++++++++--------------
>  1 files changed, 20 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/staging/comedi/drivers/ni_labpc.c b/drivers/staging/comedi/drivers/ni_labpc.c
> index 3acf7e6..bfce5c8 100644
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

There's nothing wrong with this comment that needs to be changed.

Someone need to fixup the checkpatch.pl too.

> @@ -24,7 +24,7 @@ Driver: ni_labpc
>  Description: National Instruments Lab-PC (& compatibles)
>  Author: Frank Mori Hess <fmhess@users.sourceforge.net>
>  Devices: [National Instruments] Lab-PC-1200 (labpc-1200),
> -  Lab-PC-1200AI (labpc-1200ai), Lab-PC+ (lab-pc+), PCI-1200 (ni_labpc)
> +Lab-PC-1200AI (labpc-1200ai), Lab-PC+ (lab-pc+), PCI-1200 (ni_labpc)
>  Status: works

Same here, why change this?  The indent is correct.

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
> +[1] - IRQ (optional, required for timed or externally triggered conversions)
> +[2] - DMA channel (optional)

And here, the original is fine.

>  
>  Configuration options - PCI boards:
> -  [0] - bus (optional)
> -  [1] - slot (optional)
> +[0] - bus (optional)
> +[1] - slot (optional)

Same here, original is fine.

Sorry, but there's nothing here to change.

thanks,

greg k-h

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274Ab0IUABf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 20:01:35 -0400
Received: from kroah.org ([198.145.64.141]:39188 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756670Ab0IUABd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 20:01:33 -0400
Date: Mon, 20 Sep 2010 16:59:28 -0700
From: Greg KH <greg@kroah.com>
To: Maurice Dawson <mauricedawson2699@gmail.com>
Cc: gregkh@suse.de, arun.thomas@gmail.com, stewart_r@aliencamel.com,
        u.kleine-koenig@pengutronix.de, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] Staging: comedi: fix EXPORT SYMBOL coding style
 issue in ni_labpc.c
Message-ID: <20100920235928.GC8063@kroah.com>
References: <1284922470-2624-1-git-send-email-mauricedawson2699@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284922470-2624-1-git-send-email-mauricedawson2699@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 19, 2010 at 07:54:30PM +0100, Maurice Dawson wrote:
> This is a patch to the ni_labpc.c file that fixes up, EXPORT SYMBOL(foo) should immediately follow its function/variable
> warnings, found by the checkpatch.pl tool
> 
> Signed-off-by: Maurice Dawson <mauricedawson2699@gmail.com>
> ---
>  drivers/staging/comedi/drivers/ni_labpc.c |   20 ++++++++++----------
>  1 files changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/staging/comedi/drivers/ni_labpc.c b/drivers/staging/comedi/drivers/ni_labpc.c
> index 8d120cd..f18a8a7 100644
> --- a/drivers/staging/comedi/drivers/ni_labpc.c
> +++ b/drivers/staging/comedi/drivers/ni_labpc.c
> @@ -24,7 +24,7 @@ Driver: ni_labpc
>  Description: National Instruments Lab-PC (& compatibles)
>  Author: Frank Mori Hess <fmhess@users.sourceforge.net>
>  Devices: [National Instruments] Lab-PC-1200 (labpc-1200),
> -	Lab-PC-1200AI (labpc-1200ai), Lab-PC+ (lab-pc+), PCI-1200 (ni_labpc)
> +	Lab-PC-1200AI(labpc-1200ai), Lab-PC + (lab-pc+), PCI-1200 (ni_labpc)
>  Status: works

Why make this change?

>  
>  Tested with lab-pc-1200.  For the older Lab-PC+, not all input ranges
> @@ -48,12 +48,12 @@ comedilib, use the comedi_calibrate program.
>  
>  Configuration options - ISA boards:
>  [0] - I/O port base address
> -[1] - IRQ (optional, required for timed or externally triggered conversions)
> -[2] - DMA channel (optional)
> +[1] - IRQ(optional, required for timed or externally triggered conversions)
> +[2] - DMA channel(optional)

And these?

They have nothing to do with the patch description above, right?

>  
>  Configuration options - PCI boards:
> -[0] - bus (optional)
> -[1] - slot (optional)
> +[0] - bus(optional)
> +[1] - slot(optional)

Same here.

Care to redo this?

thanks,

greg k-h

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760021Ab0GVSsg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 14:48:36 -0400
Received: from kroah.org ([198.145.64.141]:60762 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760006Ab0GVSsc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 14:48:32 -0400
Date: Thu, 22 Jul 2010 11:47:57 -0700
From: Greg KH <greg@kroah.com>
To: Chihau Chau <chihau@gmail.com>
Cc: gregkh@suse.de, mithlesh@linsyssoft.com, reodge@gmail.com,
        andrea.gelmini@gelma.net, penberg@cs.helsinki.fi,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: comedi: drivers: Code style issues
Message-ID: <20100722184757.GA14820@kroah.com>
References: <1279818473-18212-1-git-send-email-chihau@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279818473-18212-1-git-send-email-chihau@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 22, 2010 at 01:07:53PM -0400, Chihau Chau wrote:
> From: Chihau Chau <chihau@gmail.com>
> 
> This fix some lines over 80 characters.
> 
> Signed-off-by: Chihau Chau <chihau@gmail.com>
> ---
>  drivers/staging/comedi/drivers.c |   17 ++++++++---------
>  1 files changed, 8 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/staging/comedi/drivers.c b/drivers/staging/comedi/drivers.c
> index 4a29ed7..50c8295 100644
> --- a/drivers/staging/comedi/drivers.c
> +++ b/drivers/staging/comedi/drivers.c
> @@ -117,8 +117,8 @@ int comedi_device_attach(struct comedi_device *dev, struct comedi_devconfig *it)
>  
>  	for (driv = comedi_drivers; driv; driv = driv->next) {
>  		if (!try_module_get(driv->module)) {
> -			printk
> -			    (KERN_INFO "comedi: failed to increment module count, skipping\n");
> +			printk(KERN_INFO "comedi: failed to increment module "
> +				"count, skipping\n");

No, please don't break strings across lines like this, it makes it
harder to grep for things.

How about something like:
			printk(KERN_INFO "comedi: failed to increment module count, skipping\n");
instead.  That should pass the checkpatch.pl script, right?

thanks,

greg k-h

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab0LCVif (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 16:38:35 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53630 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752524Ab0LCVie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 16:38:34 -0500
Date: Fri, 3 Dec 2010 13:38:14 -0800
From: Greg KH <gregkh@suse.de>
To: Xenofon Foukas <foukas.xenofon@gmail.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH] Fix coding style issues in drivers.c
Message-ID: <20101203213814.GA14263@suse.de>
References: <1291411877-15579-1-git-send-email-foukas.xenofon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291411877-15579-1-git-send-email-foukas.xenofon@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 03, 2010 at 11:31:17PM +0200, Xenofon Foukas wrote:
> This patch fixes line over 80 characters warning issues found
> in file drivers.c
> Signed-off-by: Xenofon Foukas <foukas.xenofon@gmail.com>
> ---
>  drivers/staging/comedi/drivers.c |   26 ++++++++++++++++++--------
>  1 files changed, 18 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/staging/comedi/drivers.c b/drivers/staging/comedi/drivers.c
> index 4a29ed7..840b7e0 100644
> --- a/drivers/staging/comedi/drivers.c
> +++ b/drivers/staging/comedi/drivers.c
> @@ -118,7 +118,8 @@ int comedi_device_attach(struct comedi_device *dev, struct comedi_devconfig *it)
>  	for (driv = comedi_drivers; driv; driv = driv->next) {
>  		if (!try_module_get(driv->module)) {
>  			printk
> -			    (KERN_INFO "comedi: failed to increment module count, skipping\n");
> +			     (KERN_INFO "comedi: failed to increment "
> +						"module count, skipping\n");

No, put this all on one line, with the printk() and the warning will go
away.

Care to fix this for the other printk() change you did in this file and
resend it?

thanks,

greg k-h

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827Ab0KBNkF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 09:40:05 -0400
Received: from kroah.org ([198.145.64.141]:40428 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752769Ab0KBNj4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 09:39:56 -0400
Date: Tue, 2 Nov 2010 06:39:43 -0700
From: Greg KH <greg@kroah.com>
To: Audun Hoem <audun.hoem@gmail.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: frontier: alphatrack: Fixed coding style
	issues
Message-ID: <20101102133943.GA2032@kroah.com>
References: <1288691024-25643-1-git-send-email-audun.hoem@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288691024-25643-1-git-send-email-audun.hoem@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 02, 2010 at 10:43:44AM +0100, Audun Hoem wrote:
> From: Audun Hoem <audun.hoem@gmail.com>
> 
> I cleaned up the coding style.
> 
> Signed-off-by: Audun Hoem <audun.hoem@gmail.com>
> ---
>  drivers/staging/frontier/alphatrack.c |    9 ++++++---
>  1 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/frontier/alphatrack.c b/drivers/staging/frontier/alphatrack.c
> index ef7fbf8..9d439fa 100644
> --- a/drivers/staging/frontier/alphatrack.c
> +++ b/drivers/staging/frontier/alphatrack.c
> @@ -88,8 +88,11 @@ MODULE_SUPPORTED_DEVICE("Frontier Designs Alphatrack Control Surface");
>  static int debug = ALPHATRACK_DEBUG;
>  
>  /* Use our own dbg macro */
> -#define dbg_info(dev, format, arg...) do \
> -    { if (debug) dev_info(dev , format , ## arg); } while (0)
> +#define dbg_info(dev, format, arg...) \
> +do {
> +	if (debug)
> +		dev_info(dev , format , ## arg);
> +} while (0)

Oops, no, this doesn't work, and it breaks the build.  Did you test your
patch after you made it?

(hint, you need to add a few more '\' characters...)

Care to redo this and resend it?

thanks,

greg k-h

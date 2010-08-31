Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939Ab0HaWHL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 18:07:11 -0400
Received: from kroah.org ([198.145.64.141]:47744 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751700Ab0HaWHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 18:07:10 -0400
Date: Tue, 31 Aug 2010 15:05:06 -0700
From: Greg KH <greg@kroah.com>
To: Gunnar Gudvardarson <gunni@wave.is>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: crystalhd: crystalhd_cmds: fixed a brace issue
Message-ID: <20100831220506.GA21191@kroah.com>
References: <1282162206-9524-1-git-send-email-gunni@wave.is>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282162206-9524-1-git-send-email-gunni@wave.is>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 18, 2010 at 08:10:06PM +0000, Gunnar Gudvardarson wrote:
> Fixed a brace issue.
> 
> Signed-off-by: Gunnar Gudvardarson <gunni@wave.is>
> ---
>  drivers/staging/crystalhd/crystalhd_cmds.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/crystalhd/crystalhd_cmds.c b/drivers/staging/crystalhd/crystalhd_cmds.c
> index 1429608..d423775 100644
> --- a/drivers/staging/crystalhd/crystalhd_cmds.c
> +++ b/drivers/staging/crystalhd/crystalhd_cmds.c
> @@ -309,9 +309,9 @@ static enum BC_STATUS bc_cproc_download_fw(struct crystalhd_cmd *ctx,
>  	sts = crystalhd_download_fw(ctx->adp, (uint8_t *)idata->add_cdata,
>  				  idata->add_cdata_sz);
>  
> -	if (sts != BC_STS_SUCCESS) {
> +	if (sts != BC_STS_SUCCESS)
>  		BCMLOG_ERR("Firmware Download Failure!! - %d\n", sts);
> -	} else
> +	else

This breaks the build, are you sure you tested it after making the
patch?

thanks,

greg k-h

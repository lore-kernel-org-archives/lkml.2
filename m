Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512Ab1CAFq2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 00:46:28 -0500
Received: from kroah.org ([198.145.64.141]:43588 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755012Ab1CAFqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 00:46:24 -0500
Date: Mon, 28 Feb 2011 18:56:40 -0800
From: Greg KH <greg@kroah.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: Re: [PATCH 5/6] Staging: hv:  Rename driver_context to
 hyperv_driver
Message-ID: <20110301025640.GF1663@kroah.com>
References: <1298686058-30918-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298686058-30918-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 25, 2011 at 06:07:38PM -0800, K. Y. Srinivasan wrote:
> The title says it all.

No it doesn't.  You should have done this on the last patch to keep me
from complaining about that name.

Oh, and the extra space, drop it please.

> --- a/drivers/staging/hv/blkvsc_drv.c
> +++ b/drivers/staging/hv/blkvsc_drv.c
> @@ -116,10 +116,10 @@ struct block_device_context {
>  };
>  
>  /* Per driver */
> -struct blkvsc_driver_context {
> +struct blkvsc_hyperv_driver {
>  	/* !! These must be the first 2 fields !! */
>  	/* FIXME this is a bug! */
> -	struct driver_context drv_ctx;
> +	struct hyperv_driver drv_ctx;
>  	struct storvsc_driver_object drv_obj;
>  };
>  

Hey look, that Subject: and changelog body actually lied.  It didn't say
it all.  In fact, it didn't say enough, or you just renamed a different
structure because it felt nice.

{sigh}

One thing per patch, with full description.  I'm getting tired of
repeating Documentation/CodingStyle for this subsystem when patches are
submitted.

It's as if no one even listens to me...

{sniff}

greg k-h

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050Ab1HWXbe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 19:31:34 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:53480 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755902Ab1HWX17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 19:27:59 -0400
X-Sasl-enc: HWxN0BEKFh/1eoe0AjsIgK11+jBwNM6CeaT6Wmr5NomV 1314142078
Date: Tue, 23 Aug 2011 15:52:41 -0700
From: Greg KH <greg@kroah.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 027/117] Staging: hv: blkvsc: Get rid of the dev_type
 guid from blkvsc_drv.c
Message-ID: <20110823225241.GH9641@kroah.com>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-27-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310752065-27895-27-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 15, 2011 at 10:46:15AM -0700, K. Y. Srinivasan wrote:
> Get rid of the dev_type guid from blkvsc_drv.c as it is no longer used.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---
>  drivers/staging/hv/blkvsc_drv.c |    9 ---------
>  1 files changed, 0 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
> index 8e4c206..cb61598 100644
> --- a/drivers/staging/hv/blkvsc_drv.c
> +++ b/drivers/staging/hv/blkvsc_drv.c
> @@ -111,14 +111,6 @@ struct block_device_context {
>  
>  static const char *drv_name = "blkvsc";
>  
> -/* {32412632-86cb-44a2-9b5c-50d1417354f5} */
> -static const uuid_le dev_type = {
> -	.b = {
> -		0x32, 0x26, 0x41, 0x32, 0xcb, 0x86, 0xa2, 0x44,
> -		0x9b, 0x5c, 0x50, 0xd1, 0x41, 0x73, 0x54, 0xf5
> -	}
> -};

Could be merged with the previous patch that added the guid in the other
format, right?

greg k-h

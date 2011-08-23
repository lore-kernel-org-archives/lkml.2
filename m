Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990Ab1HWX2F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 19:28:05 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:37791 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755531Ab1HWX1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 19:27:52 -0400
X-Sasl-enc: VrrK6HSYNcpKqtUwqYeIDpe/xrxnF0V3LmfdjSILl3Lz 1314142071
Date: Tue, 23 Aug 2011 15:46:14 -0700
From: Greg KH <greg@kroah.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 012/117] Staging: hv: blkvsc: Add the
 MODULE_DEVICE_TABLE() line
Message-ID: <20110823224614.GC9641@kroah.com>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-12-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310752065-27895-12-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 15, 2011 at 10:46:00AM -0700, K. Y. Srinivasan wrote:
> Add the MODULE_DEVICE_TABLE() line in blkvsc_drv.c.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---
>  drivers/staging/hv/blkvsc_drv.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
> index 38117d96..8e4c206 100644
> --- a/drivers/staging/hv/blkvsc_drv.c
> +++ b/drivers/staging/hv/blkvsc_drv.c
> @@ -818,6 +818,7 @@ static const struct hv_vmbus_device_id id_table[] = {
>  	},
>  };
>  
> +MODULE_DEVICE_TABLE(vmbus, id_table);

Please merge this back into the patch that added the id_table to the
driver, having it separate like this is just ridiculous.

greg k-h

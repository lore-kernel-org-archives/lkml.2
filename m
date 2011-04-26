Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933041Ab1DZW7k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 18:59:40 -0400
Received: from kroah.org ([198.145.64.141]:55294 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932911Ab1DZW71 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 18:59:27 -0400
Date: Tue, 26 Apr 2011 15:56:37 -0700
From: Greg KH <greg@kroah.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: Re: [PATCH 11/25] Staging: hv: Get rid of the drv field in struct
 hv_device
Message-ID: <20110426225637.GB12897@kroah.com>
References: <1303834785-4981-1-git-send-email-kys@microsoft.com>
 <1303834842-5022-1-git-send-email-kys@microsoft.com>
 <1303834842-5022-11-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303834842-5022-11-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 09:20:28AM -0700, K. Y. Srinivasan wrote:
> Now, we can rid of the drv field in struct hv_device.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
> Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
> ---
>  drivers/staging/hv/vmbus_api.h |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/hv/vmbus_api.h b/drivers/staging/hv/vmbus_api.h
> index 51fa952..02e3587 100644
> --- a/drivers/staging/hv/vmbus_api.h
> +++ b/drivers/staging/hv/vmbus_api.h
> @@ -103,9 +103,6 @@ struct hv_driver {
>  
>  /* Base device object */
>  struct hv_device {
> -	/* the driver for this device */
> -	struct hv_driver *drv;
> -
>  	char name[64];

FYI, in the future, you can also remove this name[64] field as well as I
don't think it's ever used...

thanks,

greg k-h

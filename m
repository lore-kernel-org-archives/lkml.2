Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312Ab1GEP7k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 11:59:40 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:50093 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753520Ab1GEP7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 11:59:38 -0400
X-Sasl-enc: IIGw1n5fsyBJLlq2JF3JCP+srcyotNKgp9MAX09dvj/Y 1309881578
Date: Tue, 5 Jul 2011 08:57:45 -0700
From: Greg KH <greg@kroah.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: Re: [PATCH 75/77] Staging: hv: mouse: Disable auto-loading of the
 mouse driver
Message-ID: <20110705155745.GA31998@kroah.com>
References: <1308255393-3785-1-git-send-email-kys@microsoft.com>
 <1308255470-3826-1-git-send-email-kys@microsoft.com>
 <1308255470-3826-75-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308255470-3826-75-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 16, 2011 at 01:17:48PM -0700, K. Y. Srinivasan wrote:
> Disable auto-loading of the mouse driver.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
> ---
>  drivers/staging/hv/hv_mouse.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/hv/hv_mouse.c b/drivers/staging/hv/hv_mouse.c
> index 1b30f26..ab5f1da 100644
> --- a/drivers/staging/hv/hv_mouse.c
> +++ b/drivers/staging/hv/hv_mouse.c
> @@ -950,7 +950,7 @@ static void __exit mousevsc_exit(void)
>  
>  MODULE_LICENSE("GPL");
>  MODULE_VERSION(HV_DRV_VERSION);
> -MODULE_ALIAS("vmbus:hv_mouse");
> +/*MODULE_ALIAS("vmbus:hv_mouse");*/

Why?

{hint, I think I know why, but you need to tell us why in the changelog
comment}

Dropped.


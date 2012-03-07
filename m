Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759884Ab2CGTWb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 14:22:31 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:43805 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759852Ab2CGTWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 14:22:24 -0500
X-Sasl-enc: TXQlGT8YUeRU0vZYE0aKWs+ekq1aDa8B+KlYTZptUc68 1331148143
Date: Wed, 7 Mar 2012 11:22:04 -0800
From: Greg KH <greg@kroah.com>
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: kys@microsoft.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        Olaf Hering <olaf@aepfle.de>
Subject: Re: [PATCH] net/hyperv: Advertise hv_netvsc instead of netvsc as
 driver name
Message-ID: <20120307192204.GA9163@kroah.com>
References: <1331147131-6660-1-git-send-email-haiyangz@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331147131-6660-1-git-send-email-haiyangz@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2012 at 11:05:31AM -0800, Haiyang Zhang wrote:
> From: Olaf Hering <olaf@aepfle.de>
> 
> Signed-off-by: Olaf Hering <olaf@aepfle.de>
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---
>  drivers/net/hyperv/netvsc_drv.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
> index 0ae7a1a..53d1ee5 100644
> --- a/drivers/net/hyperv/netvsc_drv.c
> +++ b/drivers/net/hyperv/netvsc_drv.c
> @@ -40,6 +40,8 @@
>  
>  #include "hyperv_net.h"
>  
> +#define MODULE_NAME "hv_netvsc"

No, please use the built-in macro for this and don't define your own,
that's totally redundant.

greg k-h

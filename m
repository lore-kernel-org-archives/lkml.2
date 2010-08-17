Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162Ab0HQTTK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 15:19:10 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43665 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903Ab0HQTTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 15:19:01 -0400
Date: Tue, 17 Aug 2010 13:17:35 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Graeme Smecher <graeme.smecher@mail.mcgill.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Include missing headers for of_address_to_resource()
 in MTD and SysACE drivers
Message-ID: <20100817191735.GA24632@angua.secretlab.ca>
References: <1282065224-28673-1-git-send-email-graeme.smecher@mail.mcgill.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282065224-28673-1-git-send-email-graeme.smecher@mail.mcgill.ca>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 10:13:44AM -0700, Graeme Smecher wrote:
> The drivers for Xilinx' SystemACE and physically mapped MTDs were missing
> prototypes for of_address_to_resource(). This patch adds the necessary
> headers.
> 
> signed-off-by: Graeme Smecher <graeme.smecher@mail.mcgill.ca>

merged, thanks.

g.

> ---
>  drivers/block/xsysace.c       |    1 +
>  drivers/mtd/maps/physmap_of.c |    1 +
>  2 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/block/xsysace.c b/drivers/block/xsysace.c
> index 2982b3e..fa71ba5 100644
> --- a/drivers/block/xsysace.c
> +++ b/drivers/block/xsysace.c
> @@ -96,6 +96,7 @@
>  #if defined(CONFIG_OF)
>  #include <linux/of_device.h>
>  #include <linux/of_platform.h>
> +#include <linux/of_address.h>
>  #endif
>  
>  MODULE_AUTHOR("Grant Likely <grant.likely@secretlab.ca>");
> diff --git a/drivers/mtd/maps/physmap_of.c b/drivers/mtd/maps/physmap_of.c
> index 00af55d..07b13e8 100644
> --- a/drivers/mtd/maps/physmap_of.c
> +++ b/drivers/mtd/maps/physmap_of.c
> @@ -23,6 +23,7 @@
>  #include <linux/mtd/concat.h>
>  #include <linux/of.h>
>  #include <linux/of_platform.h>
> +#include <linux/of_address.h>
>  #include <linux/slab.h>
>  
>  struct of_flash_list {
> -- 
> 1.7.1
> 

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636Ab2F1XTO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 19:19:14 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:60557 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071Ab2F1XTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 19:19:11 -0400
Date: Thu, 28 Jun 2012 16:19:03 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, lenb@kernel.org,
        rui.zhang@intel.com, khali@linux-fr.org, ben-linux@fluff.org,
        w.sang@pengutronix.de, eric.piel@tremplin-utc.net, mjg@redhat.com,
        ike.pan@canonical.com, herton@canonical.com
Subject: Re: [PATCH 07/12] Input: atlas_btns - convert to module_acpi_driver()
Message-ID: <20120628231902.GA21687@core.coreip.homeip.net>
References: <1340881171-14811-1-git-send-email-mika.westerberg@linux.intel.com>
 <1340881171-14811-8-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340881171-14811-8-git-send-email-mika.westerberg@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2012 at 01:59:26PM +0300, Mika Westerberg wrote:
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Please feel free to merge with the rest of the series.

Thanks!

> ---
>  drivers/input/misc/atlas_btns.c |   17 +----------------
>  1 file changed, 1 insertion(+), 16 deletions(-)
> 
> diff --git a/drivers/input/misc/atlas_btns.c b/drivers/input/misc/atlas_btns.c
> index 601f737..26f1313 100644
> --- a/drivers/input/misc/atlas_btns.c
> +++ b/drivers/input/misc/atlas_btns.c
> @@ -151,22 +151,7 @@ static struct acpi_driver atlas_acpi_driver = {
>  		.remove	= atlas_acpi_button_remove,
>  	},
>  };
> -
> -static int __init atlas_acpi_init(void)
> -{
> -	if (acpi_disabled)
> -		return -ENODEV;
> -
> -	return acpi_bus_register_driver(&atlas_acpi_driver);
> -}
> -
> -static void __exit atlas_acpi_exit(void)
> -{
> -	acpi_bus_unregister_driver(&atlas_acpi_driver);
> -}
> -
> -module_init(atlas_acpi_init);
> -module_exit(atlas_acpi_exit);
> +module_acpi_driver(atlas_acpi_driver);
>  
>  MODULE_AUTHOR("Jaya Kumar");
>  MODULE_LICENSE("GPL");
> -- 
> 1.7.10
> 

-- 
Dmitry

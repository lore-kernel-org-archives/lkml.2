Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194Ab2F2MuT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 08:50:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37860 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710Ab2F2MuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 08:50:18 -0400
Date: Fri, 29 Jun 2012 09:50:09 -0300
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, lenb@kernel.org,
        rui.zhang@intel.com, khali@linux-fr.org, ben-linux@fluff.org,
        w.sang@pengutronix.de, dmitry.torokhov@gmail.com,
        eric.piel@tremplin-utc.net, mjg@redhat.com, ike.pan@canonical.com,
        herton@canonical.com
Subject: Re: [PATCH 10/12] topstar-laptop: convert to module_acpi_driver()
Message-ID: <20120629125008.GA13595@herton-Z68MA-D2H-B3>
References: <1340881171-14811-1-git-send-email-mika.westerberg@linux.intel.com>
 <1340881171-14811-11-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340881171-14811-11-git-send-email-mika.westerberg@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2012 at 01:59:29PM +0300, Mika Westerberg wrote:
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> ---
>  drivers/platform/x86/topstar-laptop.c |   22 +---------------------
>  1 file changed, 1 insertion(+), 21 deletions(-)

Acked-by: Herton R. Krzesinski <herton@canonical.com>

> 
> diff --git a/drivers/platform/x86/topstar-laptop.c b/drivers/platform/x86/topstar-laptop.c
> index d528daa..d727bfe 100644
> --- a/drivers/platform/x86/topstar-laptop.c
> +++ b/drivers/platform/x86/topstar-laptop.c
> @@ -186,27 +186,7 @@ static struct acpi_driver acpi_topstar_driver = {
>  		.notify = acpi_topstar_notify,
>  	},
>  };
> -
> -static int __init topstar_laptop_init(void)
> -{
> -	int ret;
> -
> -	ret = acpi_bus_register_driver(&acpi_topstar_driver);
> -	if (ret < 0)
> -		return ret;
> -
> -	pr_info("ACPI extras driver loaded\n");
> -
> -	return 0;
> -}
> -
> -static void __exit topstar_laptop_exit(void)
> -{
> -	acpi_bus_unregister_driver(&acpi_topstar_driver);
> -}
> -
> -module_init(topstar_laptop_init);
> -module_exit(topstar_laptop_exit);
> +module_acpi_driver(acpi_topstar_driver);
>  
>  MODULE_AUTHOR("Herton Ronaldo Krzesinski");
>  MODULE_DESCRIPTION("Topstar Laptop ACPI Extras driver");
> -- 
> 1.7.10
> 

-- 
[]'s
Herton

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933322Ab2GDLT7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 07:19:59 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:4689 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932541Ab2GDLT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 07:19:57 -0400
Date: Wed, 4 Jul 2012 13:19:37 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, lenb@kernel.org,
        rui.zhang@intel.com, ben-linux@fluff.org, w.sang@pengutronix.de,
        dmitry.torokhov@gmail.com, eric.piel@tremplin-utc.net, mjg@redhat.com,
        ike.pan@canonical.com, herton@canonical.com
Subject: Re: [PATCH 06/12] i2c-scmi: convert to module_acpi_driver()
Message-ID: <20120704131937.41194e7e@endymion.delvare>
In-Reply-To: <1340881171-14811-7-git-send-email-mika.westerberg@linux.intel.com>
References: <1340881171-14811-1-git-send-email-mika.westerberg@linux.intel.com>
	<1340881171-14811-7-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jun 2012 13:59:25 +0300, Mika Westerberg wrote:
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> ---
>  drivers/i2c/busses/i2c-scmi.c |   14 +-------------
>  1 file changed, 1 insertion(+), 13 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-scmi.c b/drivers/i2c/busses/i2c-scmi.c
> index 388cbdc..6aafa3d 100644
> --- a/drivers/i2c/busses/i2c-scmi.c
> +++ b/drivers/i2c/busses/i2c-scmi.c
> @@ -426,19 +426,7 @@ static struct acpi_driver acpi_smbus_cmi_driver = {
>  		.remove = acpi_smbus_cmi_remove,
>  	},
>  };
> -
> -static int __init acpi_smbus_cmi_init(void)
> -{
> -	return acpi_bus_register_driver(&acpi_smbus_cmi_driver);
> -}
> -
> -static void __exit acpi_smbus_cmi_exit(void)
> -{
> -	acpi_bus_unregister_driver(&acpi_smbus_cmi_driver);
> -}
> -
> -module_init(acpi_smbus_cmi_init);
> -module_exit(acpi_smbus_cmi_exit);
> +module_acpi_driver(acpi_smbus_cmi_driver);
>  
>  MODULE_LICENSE("GPL");
>  MODULE_AUTHOR("Crane Cai <crane.cai@amd.com>");

Acked-by: Jean Delvare <khali@linux-fr.org>

-- 
Jean Delvare

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757149Ab2GDK35 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 06:29:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55779 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757030Ab2GDK3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 06:29:55 -0400
Message-ID: <4FF41B17.3030304@canonical.com>
Date: Wed, 04 Jul 2012 18:29:43 +0800
From: Ike Panhc <ike.pan@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Mika Westerberg <mika.westerberg@linux.intel.com>
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, lenb@kernel.org,
        rui.zhang@intel.com, khali@linux-fr.org, ben-linux@fluff.org,
        w.sang@pengutronix.de, dmitry.torokhov@gmail.com,
        eric.piel@tremplin-utc.net, mjg@redhat.com, herton@canonical.com
Subject: Re: [PATCH 09/12] ideapad: convert to module_acpi_driver()
References: <1340881171-14811-1-git-send-email-mika.westerberg@linux.intel.com> <1340881171-14811-10-git-send-email-mika.westerberg@linux.intel.com>
In-Reply-To: <1340881171-14811-10-git-send-email-mika.westerberg@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2012 06:59 PM, Mika Westerberg wrote:
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Acked-by: Ike Panhc <ike.pan@canonical.com>

> ---
>  drivers/platform/x86/ideapad-laptop.c |   14 +-------------
>  1 file changed, 1 insertion(+), 13 deletions(-)
> 
> diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
> index 4f20f8d..b469654 100644
> --- a/drivers/platform/x86/ideapad-laptop.c
> +++ b/drivers/platform/x86/ideapad-laptop.c
> @@ -813,20 +813,8 @@ static struct acpi_driver ideapad_acpi_driver = {
>  	.ops.notify = ideapad_acpi_notify,
>  	.owner = THIS_MODULE,
>  };
> -
> -static int __init ideapad_acpi_module_init(void)
> -{
> -	return acpi_bus_register_driver(&ideapad_acpi_driver);
> -}
> -
> -static void __exit ideapad_acpi_module_exit(void)
> -{
> -	acpi_bus_unregister_driver(&ideapad_acpi_driver);
> -}
> +module_acpi_driver(ideapad_acpi_driver);
>  
>  MODULE_AUTHOR("David Woodhouse <dwmw2@infradead.org>");
>  MODULE_DESCRIPTION("IdeaPad ACPI Extras");
>  MODULE_LICENSE("GPL");
> -
> -module_init(ideapad_acpi_module_init);
> -module_exit(ideapad_acpi_module_exit);
> 



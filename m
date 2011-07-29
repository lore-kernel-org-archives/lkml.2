Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179Ab1G2WCO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 18:02:14 -0400
Received: from smtprelay03.ispgateway.de ([80.67.31.37]:38291 "EHLO
	smtprelay03.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992Ab1G2WCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 18:02:12 -0400
X-Greylist: delayed 371 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Jul 2011 18:02:12 EDT
References: <20110728180535.51dce58d@boyarsh.office.altlinux.ru>
Message-ID: <cone.1311976558.82572.3703.1000@deskpiie>
X-Mailer: http://www.courier-mta.org/cone/
From: Peter Feuerer <peter@piie.net>
To: Anton =?UTF-8?B?Vi4=?= Boyarshinov <boyarsh@altlinux.org>
Cc: Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] acerhdf.c: spaces in aliased changed to *
Date: Fri, 29 Jul 2011 23:55:58 +0200
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
X-Df-Sender: 404094
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Matthew, please apply, thanks.

Anton V. Boyarshinov writes:
> It seems that aliases shouldn't contain spaces, as 
> module-init-tools uses them as delimeters in module.alias file
> 
> Signed-off-by: Anton V. Boyarshinov <boyarsh@altlinux.org>

Acked-by: Peter Feuerer <peter@piie.net>

> ---
>  drivers/platform/x86/acerhdf.c |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
> index fca3489..7a8568b 100644
> --- a/drivers/platform/x86/acerhdf.c
> +++ b/drivers/platform/x86/acerhdf.c
> @@ -703,15 +703,15 @@ MODULE_LICENSE("GPL");
>  MODULE_AUTHOR("Peter Feuerer");
>  MODULE_DESCRIPTION("Aspire One temperature and fan driver");
>  MODULE_ALIAS("dmi:*:*Acer*:pnAOA*:");
> -MODULE_ALIAS("dmi:*:*Acer*:pnAspire 1410*:");
> -MODULE_ALIAS("dmi:*:*Acer*:pnAspire 1810*:");
> +MODULE_ALIAS("dmi:*:*Acer*:pnAspire*1410*:");
> +MODULE_ALIAS("dmi:*:*Acer*:pnAspire*1810*:");
>  MODULE_ALIAS("dmi:*:*Acer*:pnAO531*:");
>  MODULE_ALIAS("dmi:*:*Gateway*:pnAOA*:");
>  MODULE_ALIAS("dmi:*:*Gateway*:pnLT31*:");
> -MODULE_ALIAS("dmi:*:*Packard Bell*:pnAOA*:");
> -MODULE_ALIAS("dmi:*:*Packard Bell*:pnDOA*:");
> -MODULE_ALIAS("dmi:*:*Packard Bell*:pnDOTMU*:");
> -MODULE_ALIAS("dmi:*:*Packard Bell*:pnDOTMA*:");
> +MODULE_ALIAS("dmi:*:*Packard*Bell*:pnAOA*:");
> +MODULE_ALIAS("dmi:*:*Packard*Bell*:pnDOA*:");
> +MODULE_ALIAS("dmi:*:*Packard*Bell*:pnDOTMU*:");
> +MODULE_ALIAS("dmi:*:*Packard*Bell*:pnDOTMA*:");
>  
>  module_init(acerhdf_init);
>  module_exit(acerhdf_exit);
> -- 
> 1.7.2.2
> 

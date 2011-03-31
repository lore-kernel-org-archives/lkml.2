Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781Ab1CaGlj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 02:41:39 -0400
Received: from novprvlin0050.provo.novell.com ([137.65.248.33]:35780 "EHLO
	novprvlin0050.provo.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751386Ab1CaGlf (ORCPT
	<rfc822;groupwise-jlee@novell.com:3:1>);
	Thu, 31 Mar 2011 02:41:35 -0400
Message-Id: <4D94BCCC020000230002AA37@novprvlin0050.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.2 
Date: Thu, 31 Mar 2011 00:41:32 -0600
From: "Joey Lee" <jlee@novell.com>
To: <joe@perches.com>
Cc: <mjg@redhat.com>, <linux-kernel@vger.kernel.org>,
        <platform-driver-x86@vger.kernel.org>
Subject: Re: [PATCH 15/23] msi-laptop: pr_<level> neatening
References: <cover.1301436234.git.joe@perches.com>
 <d4a53369c7b28b2c673661325b75c6eb23f61505.1301436234.git.joe@perches.com>
In-Reply-To: <d4a53369c7b28b2c673661325b75c6eb23f61505.1301436234.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 二，2011-03-29 於 15:21 -0700，Joe Perches 提到：
> Just making it a bit more like other logging message uses.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/platform/x86/msi-laptop.c |    9 ++++-----
>  1 files changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/platform/x86/msi-laptop.c b/drivers/platform/x86/msi-laptop.c
> index 23fb2af..f89c0b6 100644
> --- a/drivers/platform/x86/msi-laptop.c
> +++ b/drivers/platform/x86/msi-laptop.c
> @@ -447,7 +447,7 @@ static struct platform_device *msipf_device;
>  
>  static int dmi_check_cb(const struct dmi_system_id *id)
>  {
> -	pr_info("Identified laptop model '%s'.\n", id->ident);
> +	pr_info("Identified laptop model '%s'\n", id->ident);
>  	return 1;
>  }
>  
> @@ -875,8 +875,7 @@ static int __init msi_init(void)
>  	/* Register backlight stuff */
>  
>  	if (acpi_video_backlight_support()) {
> -		pr_info("Brightness ignored, must be controlled "
> -		       "by ACPI video driver\n");
> +		pr_info("Brightness ignored, must be controlled by ACPI video driver\n");
>  	} else {
>  		struct backlight_properties props;
>  		memset(&props, 0, sizeof(struct backlight_properties));
> @@ -930,7 +929,7 @@ static int __init msi_init(void)
>  	if (auto_brightness != 2)
>  		set_auto_brightness(auto_brightness);
>  
> -	pr_info("driver "MSI_DRIVER_VERSION" successfully loaded.\n");
> +	pr_info("driver " MSI_DRIVER_VERSION " successfully loaded\n");
>  
>  	return 0;
>  
> @@ -978,7 +977,7 @@ static void __exit msi_cleanup(void)
>  	if (auto_brightness != 2)
>  		set_auto_brightness(1);
>  
> -	pr_info("driver unloaded.\n");
> +	pr_info("driver unloaded\n");
>  }
>  
>  module_init(msi_init);

Thank's, it's ok to me.

Acked-by: Lee, Chun-Yi <jlee@novell.com>


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751055Ab1ADWh5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 17:37:57 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44945 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750833Ab1ADWh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 17:37:56 -0500
Date: Tue, 4 Jan 2011 14:36:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mourad De Clerck <mourad@aquazul.com>
Cc: Richard Purdie <rpurdie@linux.intel.com>, linux-kernel@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH,RESEND] backlight: mbp_nvidia_bl - add support for
 MacBookPro7,1
Message-Id: <20110104143651.8f6d62e0.akpm@linux-foundation.org>
In-Reply-To: <4D145EB5.7090205@aquazul.com>
References: <4D145EB5.7090205@aquazul.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Dec 2010 09:49:57 +0100
Mourad De Clerck <mourad@aquazul.com> wrote:

> Add support for the MacBookPro7,1 (13" mid 2010) to the mbp_nvidia_bl
> driver.
> 
> Signed-off-by: Mourad De Clerck <mourad@aquazul.com>
> ---
>  drivers/video/backlight/mbp_nvidia_bl.c |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/video/backlight/mbp_nvidia_bl.c
> b/drivers/video/backlight/mbp_nvidia_bl.c
> index 9fb533f..9c44314 100644
> --- a/drivers/video/backlight/mbp_nvidia_bl.c
> +++ b/drivers/video/backlight/mbp_nvidia_bl.c
> @@ -335,6 +335,15 @@ static const struct dmi_system_id __initdata
> mbp_device_table[] = {
>  		},
>  		.driver_data	= (void *)&nvidia_chipset_data,
>  	},
> +	{
> +		.callback	= mbp_dmi_match,
> +		.ident		= "MacBookPro 7,1",
> +		.matches	= {
> +			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro7,1"),
> +		},
> +		.driver_data	= (void *)&nvidia_chipset_data,
> +	},
>  	{ }
>  };

I applied this, and now I'll unapply it because Matthew's patch series
"mbp_nvidia_bl: Remove DMI dependency" appears to make your change
obsolete.

I'll cc you on those three patches - it will be great if you are able
to find time to test them, thanks.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935546Ab1JFIjA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 04:39:00 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:42110 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932384Ab1JFIi6 (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Thu, 6 Oct 2011 04:38:58 -0400
Subject: Re: [PATCH] acer-wmi: Add wireless quirk for Lenovo 3000 N200
From: joeyli <jlee@suse.com>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: Joey Lee <jlee@novell.com>, Matthew Garrett <mjg@redhat.com>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1317756778-11822-1-git-send-email-seth.forshee@canonical.com>
References: <1317756778-11822-1-git-send-email-seth.forshee@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 06 Oct 2011 16:38:34 +0800
Message-ID: <1317890314.11626.115.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Seth, 

於 二，2011-10-04 於 14:32 -0500，Seth Forshee 提到：
> This quirk fixes the wlan rfkill status on this machine. Without
> it, wlan is permanently soft blocked whenever acer-wmi is loaded.
> 
> BugLink: https://bugs.launchpad.net/bugs/865807
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> ---
>  drivers/platform/x86/acer-wmi.c |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
> index af2bb20..dac286a 100644
> --- a/drivers/platform/x86/acer-wmi.c
> +++ b/drivers/platform/x86/acer-wmi.c
> @@ -464,6 +464,15 @@ static struct dmi_system_id acer_quirks[] = {
>  		},
>  		.driver_data = &quirk_lenovo_ideapad_s205,
>  	},
> +	{
> +		.callback = dmi_matched,
> +		.ident = "Lenovo 3000 N200",
> +		.matches = {
> +			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "0687A31"),
> +		},
> +		.driver_data = &quirk_fujitsu_amilo_li_1718,
> +	},
>  	{}
>  };
>  

Simple applied and tested on my acer machine, no problem!

Reviewed-by: Lee, Chun-Yi <jlee@novell.com>

Thank's for your patch!
Joey Lee


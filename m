Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757781Ab2K0Gcy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 01:32:54 -0500
Received: from smtp.nue.novell.com ([195.135.221.5]:50611 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755906Ab2K0Gcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 01:32:53 -0500
Subject: Re: [PATCH] acer-wmi: add Aspire 5741G touchpad toggle key
From: joeyli <jlee@suse.com>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Joey Lee <jlee@novell.com>, Matthew Garrett <mjg@redhat.com>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20121126183502.GA2749@swordfish>
References: <20121126183502.GA2749@swordfish>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Nov 2012 14:31:52 +0800
Message-ID: <1353997912.21227.862.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 一，2012-11-26 於 21:35 +0300，Sergey Senozhatsky 提到：
> Add Aspire 5741G KEY_TOUCHPAD_TOGGLE to wmi keymap, preventing
> "acer_wmi: Unknown key number - 0x85" error.
> 
> 
> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

Signed-off-by: Lee, Chun-Yi <jlee@suse.com>

Thanks for you resend your patch. 

Joey Lee

> 
> ---
> 
>  drivers/platform/x86/acer-wmi.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
> index 934d861..9a6ee9a 100644
> --- a/drivers/platform/x86/acer-wmi.c
> +++ b/drivers/platform/x86/acer-wmi.c
> @@ -127,6 +127,7 @@ static const struct key_entry acer_wmi_keymap[] = {
>  	{KE_IGNORE, 0x81, {KEY_SLEEP} },
>  	{KE_KEY, 0x82, {KEY_TOUCHPAD_TOGGLE} },	/* Touch Pad On/Off */
>  	{KE_IGNORE, 0x83, {KEY_TOUCHPAD_TOGGLE} },
> +	{KE_KEY, 0x85, {KEY_TOUCHPAD_TOGGLE} },
>  	{KE_END, 0}
>  };
> 
> 



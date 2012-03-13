Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759442Ab2CMC76 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 22:59:58 -0400
Received: from nat.nue.novell.com ([195.135.221.2]:12602 "EHLO
	nat.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754541Ab2CMC75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 22:59:57 -0400
Subject: Re: [PATCH] acer-wmi: ignore missing Aspire 5741G keys
 (checkpatched)
From: joeyli <jlee@suse.com>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Joey Lee <jlee@novell.com>, Matthew Garrett <mjg@redhat.com>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20120312100643.GA24726@swordfish.minsk.epam.com>
References: <20120306123355.GA3904@swordfish.minsk.epam.com>
	 <1331266669.10557.107.camel@linux-s257.site>
	 <20120312100643.GA24726@swordfish.minsk.epam.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Mar 2012 10:58:19 +0800
Message-ID: <1331607499.10557.143.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 一，2012-03-12 於 13:07 +0300，Sergey Senozhatsky 提到：
> acer-wmi: ignore missing Aspire 5741G keys
> 
> Ignore Aspire's 5741G:
>  KEY_PREVIOUSSONG
>  KEY_NEXTSONG
>  KEY_PLAYPAUSE
>  KEY_STOP
>  KEY_VOLUMEDOWN
>  
> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> 
> ---
> 
>  drivers/platform/x86/acer-wmi.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
> index b848277..e45b9ad 100644
> --- a/drivers/platform/x86/acer-wmi.c
> +++ b/drivers/platform/x86/acer-wmi.c
> @@ -107,11 +107,16 @@ static const struct key_entry acer_wmi_keymap[] = {
>  	{KE_KEY, 0x24, {KEY_PROG4} },    /* Social networking_Key */
>  	{KE_IGNORE, 0x41, {KEY_MUTE} },
>  	{KE_IGNORE, 0x42, {KEY_PREVIOUSSONG} },
> +	{KE_IGNORE, 0x4d, {KEY_PREVIOUSSONG} },
>  	{KE_IGNORE, 0x43, {KEY_NEXTSONG} },
> +	{KE_IGNORE, 0x4e, {KEY_NEXTSONG} },
>  	{KE_IGNORE, 0x44, {KEY_PLAYPAUSE} },
> +	{KE_IGNORE, 0x4f, {KEY_PLAYPAUSE} },
>  	{KE_IGNORE, 0x45, {KEY_STOP} },
> +	{KE_IGNORE, 0x50, {KEY_STOP} },
>  	{KE_IGNORE, 0x48, {KEY_VOLUMEUP} },
>  	{KE_IGNORE, 0x49, {KEY_VOLUMEDOWN} },
> +	{KE_IGNORE, 0x4a, {KEY_VOLUMEDOWN} },
>  	{KE_IGNORE, 0x61, {KEY_SWITCHVIDEOMODE} },
>  	{KE_IGNORE, 0x62, {KEY_BRIGHTNESSUP} },
>  	{KE_IGNORE, 0x63, {KEY_BRIGHTNESSDOWN} },
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

Acked-by: Lee, Chun-Yi <jlee@suse.com>


Thanks for your patch!
Joey Lee


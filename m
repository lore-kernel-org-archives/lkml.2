Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934071Ab2C3K1s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 06:27:48 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:49342 "EHLO
	nat.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933663Ab2C3K1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 06:27:41 -0400
Subject: Re: [PATCH] acer-wmi: add Aspire 5741G touchpad toggle key
From: joeyli <jlee@suse.com>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Joey Lee <jlee@novell.com>, Matthew Garrett <mjg@redhat.com>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20120329095322.GA3576@swordfish.minsk.epam.com>
References: <20120306123355.GA3904@swordfish.minsk.epam.com>
	 <1331266669.10557.107.camel@linux-s257.site>
	 <20120312101956.GA8522@swordfish.minsk.epam.com>
	 <1331607878.10557.145.camel@linux-s257.site>
	 <20120329095322.GA3576@swordfish.minsk.epam.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 30 Mar 2012 18:25:36 +0800
Message-ID: <1333103136.7293.18.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sergey, 

於 四，2012-03-29 於 12:53 +0300，Sergey Senozhatsky 提到：
> acer-wmi: add Aspire 5741G touchpad toggle key
> 
> add Aspire 5741G KEY_TOUCHPAD_TOGGLE to wmi keymap.
> 
> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> 
> ---
> 
>  drivers/platform/x86/acer-wmi.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
> index c1a3fd8..94a6747 100644
> --- a/drivers/platform/x86/acer-wmi.c
> +++ b/drivers/platform/x86/acer-wmi.c
> @@ -125,6 +125,7 @@ static const struct key_entry acer_wmi_keymap[] = {
>  	{KE_KEY, 0x64, {KEY_SWITCHVIDEOMODE} },	/* Display Switch */
>  	{KE_IGNORE, 0x81, {KEY_SLEEP} },
>  	{KE_KEY, 0x82, {KEY_TOUCHPAD_TOGGLE} },	/* Touch Pad On/Off */
> +	{KE_KEY, 0x85, {KEY_TOUCHPAD_TOGGLE} },
>  	{KE_IGNORE, 0x83, {KEY_TOUCHPAD_TOGGLE} },
>  	{KE_END, 0}
>  };
> 

Acked-by: Lee, Chun-Yi <jlee@suse.com>


This patch is OK to me!


Thanks for your patch!
Joey Lee


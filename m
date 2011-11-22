Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756569Ab1KVUPs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 15:15:48 -0500
Received: from mail209.messagelabs.com ([216.82.255.3]:54646 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754849Ab1KVUPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 15:15:46 -0500
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-4.tower-209.messagelabs.com!1321992913!18743692!6
X-Originating-IP: [216.166.12.180]
X-StarScan-Version: 6.3.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: JJ Ding <jj_ding@emc.com.tw>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Grant Likely <grant.likely@secretlab.ca>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        JJ Ding <dgdunix@gmail.com>
Date: Tue, 22 Nov 2011 14:15:09 -0600
Subject: RE: [PATCH TRIVIAL 1/5] Input: keyboard: use macro
 module_platform_driver()
Thread-Topic: [PATCH TRIVIAL 1/5] Input: keyboard: use macro
 module_platform_driver()
Thread-Index: Acyo9iSSk67Qa90lSNCqcsejOQ5wiQAXRy+w
Message-ID: <ADE657CA350FB648AAC2C43247A983F001F3E96DA6B1@AUSP01VMBX24.collaborationhost.net>
References: <1321952446-7591-1-git-send-email-jj_ding@emc.com.tw>
 <1321952446-7591-2-git-send-email-jj_ding@emc.com.tw>
In-Reply-To: <1321952446-7591-2-git-send-email-jj_ding@emc.com.tw>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pAMKG0cn001820

On Tuesday, November 22, 2011 2:01 AM, JJ Ding wrote:
> 
> Commit 940ab88962bc1aff3273a8356d64577a6e386736 introduced a new macro to
> save some platform_driver boilerplate code. Use it.
> 
> Signed-off-by: JJ Ding <dgdunix@gmail.com>
> ---
>  drivers/input/keyboard/ep93xx_keypad.c      |   14 +-------------
> 
> diff --git a/drivers/input/keyboard/ep93xx_keypad.c b/drivers/input/keyboard/ep93xx_keypad.c
> index 4662c5d..0ba69f3 100644
> --- a/drivers/input/keyboard/ep93xx_keypad.c
> +++ b/drivers/input/keyboard/ep93xx_keypad.c
> @@ -390,19 +390,7 @@ static struct platform_driver ep93xx_keypad_driver = {
>  	.suspend	= ep93xx_keypad_suspend,
>  	.resume		= ep93xx_keypad_resume,
>  };
> -
> -static int __init ep93xx_keypad_init(void)
> -{
> -	return platform_driver_register(&ep93xx_keypad_driver);
> -}
> -
> -static void __exit ep93xx_keypad_exit(void)
> -{
> -	platform_driver_unregister(&ep93xx_keypad_driver);
> -}
> -
> -module_init(ep93xx_keypad_init);
> -module_exit(ep93xx_keypad_exit);
> +module_platform_driver(ep93xx_keypad_driver);
>  
>  MODULE_LICENSE("GPL");
>  MODULE_AUTHOR("H Hartley Sweeten <hsweeten@visionengravers.com>");

Acked-by: H Hartley Sweeten <hsweeten@visionengravers.com>

Thanks!ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122Ab1K1R27 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 12:28:59 -0500
Received: from mail209.messagelabs.com ([216.82.255.3]:21275 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056Ab1K1R26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 12:28:58 -0500
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-8.tower-209.messagelabs.com!1322501327!23298045!13
X-Originating-IP: [216.166.12.180]
X-StarScan-Version: 6.3.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Axel Lin <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Haojian Zhuang <haojian.zhuang@marvell.com>,
        Mike Rapoport <mike@compulab.co.il>,
        Richard Purdie <rpurdie@rpsys.net>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 28 Nov 2011 11:28:36 -0600
Subject: RE: [PATCH] backlight: convert drivers/video/backlight/* to use
 module_platform_driver()
Thread-Topic: [PATCH] backlight: convert drivers/video/backlight/* to use
 module_platform_driver()
Thread-Index: Acyr4fFFZJ++KQfZRy2WEvrHHahFgwCEPdgg
Message-ID: <ADE657CA350FB648AAC2C43247A983F001F3E96DACD5@AUSP01VMBX24.collaborationhost.net>
References: <1322273963.10633.1.camel@phoenix>
In-Reply-To: <1322273963.10633.1.camel@phoenix>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id pASHT8Lt001216

On Friday, November 25, 2011 7:19 PM, Axel Lin wrote:
> This patch converts the drivers in drivers/video/backlight/* to use the
> module_platform_driver() macro which makes the code smaller and a bit
> simpler.
> 
> Cc: Haojian Zhuang <haojian.zhuang@marvell.com>
> Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Mike Rapoport <mike@compulab.co.il>
> Cc: Richard Purdie <rpurdie@rpsys.net>
> Cc: Michael Hennerich <michael.hennerich@analog.com>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---

[...]

>  drivers/video/backlight/ep93xx_bl.c          |   12 +-----------

[...]

> diff --git a/drivers/video/backlight/ep93xx_bl.c b/drivers/video/backlight/ep93xx_bl.c
> index c74a6f4..32b9167 100644
> --- a/drivers/video/backlight/ep93xx_bl.c
> +++ b/drivers/video/backlight/ep93xx_bl.c
> @@ -144,17 +144,7 @@ static struct platform_driver ep93xxbl_driver = {
>  	.resume		= ep93xxbl_resume,
>  };
>  
> -static int __init ep93xxbl_init(void)
> -{
> -	return platform_driver_register(&ep93xxbl_driver);
> -}
> -module_init(ep93xxbl_init);
> -
> -static void __exit ep93xxbl_exit(void)
> -{
> -	platform_driver_unregister(&ep93xxbl_driver);
> -}
> -module_exit(ep93xxbl_exit);
> +module_platform_driver(ep93xxbl_driver);
>  
>  MODULE_DESCRIPTION("EP93xx Backlight Driver");
>  MODULE_AUTHOR("H Hartley Sweeten <hsweeten@visionengravers.com>");

For ep93xx_bl.c:

Acked-by: H Hartley Sweeten <hsweeten@visionengravers.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145Ab1HVQgX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 12:36:23 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:62031 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108Ab1HVQgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 12:36:20 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-127.messagelabs.com!1314030955!25267367!36
X-StarScan-Version: 6.2.17; banners=-,-,-
X-Originating-IP: [216.166.12.180]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Axel Lin <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Paul Mundt <lethal@linux-sh.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>
Date: Mon, 22 Aug 2011 11:36:15 -0500
Subject: RE: [PATCH] video: ep93xx-fb: add missing include of linux/module.h
Thread-Topic: [PATCH] video: ep93xx-fb: add missing include of linux/module.h
Thread-Index: AcxgEDxJpgOLQYwhTH29nx45IMhjQgA2Tqng
Message-ID: <ADE657CA350FB648AAC2C43247A983F001F38857524B@AUSP01VMBX24.collaborationhost.net>
References: <1313937545.13671.5.camel@phoenix>
In-Reply-To: <1313937545.13671.5.camel@phoenix>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p7MGaXeG021694

On Sunday, August 21, 2011 7:39 AM, Axel Lin wrote:
>
> ep93xx-fb.c uses interfaces from linux/module.h,
> so it should include that file.  This patch fixes below build errors.
> 
>   CC      drivers/video/ep93xx-fb.o
> drivers/video/ep93xx-fb.c:120: error: expected ')' before 'int'
> drivers/video/ep93xx-fb.c:122: error: expected ')' before string constant
> drivers/video/ep93xx-fb.c:409: error: 'THIS_MODULE' undeclared here (not in a function)
> drivers/video/ep93xx-fb.c:645: error: expected declaration specifiers or '...' before string constant
> drivers/video/ep93xx-fb.c:645: warning: data definition has no type or storage class
> drivers/video/ep93xx-fb.c:645: warning: type defaults to 'int' in declaration of 'MODULE_DESCRIPTION'
> drivers/video/ep93xx-fb.c:645: warning: function declaration isn't a prototype
> drivers/video/ep93xx-fb.c:646: error: expected declaration specifiers or '...' before string constant
> drivers/video/ep93xx-fb.c:646: warning: data definition has no type or storage class
> drivers/video/ep93xx-fb.c:646: warning: type defaults to 'int' in declaration of 'MODULE_ALIAS'
> drivers/video/ep93xx-fb.c:646: warning: function declaration isn't a prototype
> drivers/video/ep93xx-fb.c:647: error: expected declaration specifiers or '...' before string constant
> drivers/video/ep93xx-fb.c:647: warning: data definition has no type or storage class
> drivers/video/ep93xx-fb.c:647: warning: type defaults to 'int' in declaration of 'MODULE_AUTHOR'
> drivers/video/ep93xx-fb.c:647: warning: function declaration isn't a prototype
> drivers/video/ep93xx-fb.c:649: error: expected declaration specifiers or '...' before string constant
> drivers/video/ep93xx-fb.c:649: warning: data definition has no type or storage class
> drivers/video/ep93xx-fb.c:649: warning: type defaults to 'int' in declaration of 'MODULE_LICENSE'
> drivers/video/ep93xx-fb.c:649: warning: function declaration isn't a prototype
> make[2]: *** [drivers/video/ep93xx-fb.o] Error 1
> make[1]: *** [drivers/video] Error 2
> make: *** [drivers] Error 2
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/video/ep93xx-fb.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/video/ep93xx-fb.c b/drivers/video/ep93xx-fb.c
> index 40e5f17..8133a9d 100644
> --- a/drivers/video/ep93xx-fb.c
> +++ b/drivers/video/ep93xx-fb.c
> @@ -17,6 +17,7 @@
>   *
>   */
>  
> +#include <linux/module.h>
>  #include <linux/platform_device.h>
>  #include <linux/dma-mapping.h>
>  #include <linux/slab.h>

Same issue as the backlight driver...

Acked-by: H Hartley Sweeten <hsweeten@visionengravers.com>

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

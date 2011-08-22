Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431Ab1HVQ3f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 12:29:35 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:9410 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496Ab1HVQ3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 12:29:31 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-4.tower-127.messagelabs.com!1314030560!29125239!30
X-StarScan-Version: 6.2.17; banners=-,-,-
X-Originating-IP: [216.166.12.69]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Axel Lin <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Date: Mon, 22 Aug 2011 11:29:27 -0500
Subject: RE: [PATCH] Input: ep93xx_keypad - add missing include of
 linux/module.h
Thread-Topic: [PATCH] Input: ep93xx_keypad - add missing include of
 linux/module.h
Thread-Index: Acxf34FEJFhAesZCRfKuCE2JEVlfnwBCQxKw
Message-ID: <ADE657CA350FB648AAC2C43247A983F001F388575242@AUSP01VMBX24.collaborationhost.net>
References: <1313916653.17491.1.camel@phoenix>
In-Reply-To: <1313916653.17491.1.camel@phoenix>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p7MGThde021595

On Sunday, August 21, 2011 1:51 AM, Axel Lin wrote:
>
> ep93xx_keypad.c uses interfaces from linux/module.h,
> so it should include that file.  This patch fixes build errors.
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/input/keyboard/ep93xx_keypad.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/input/keyboard/ep93xx_keypad.c b/drivers/input/keyboard/ep93xx_keypad.c
> index c8242dd..aa17e02 100644
> --- a/drivers/input/keyboard/ep93xx_keypad.c
> +++ b/drivers/input/keyboard/ep93xx_keypad.c
> @@ -20,6 +20,7 @@
>   * flag.
>   */
>  
> +#include <linux/module.h>
>  #include <linux/platform_device.h>
>  #include <linux/interrupt.h>
>  #include <linux/clk.h>

Acked-by: H Hartley Sweeten <hsweeten@visionengravers.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

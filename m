Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756397Ab1FGQbN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 12:31:13 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:19577 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756368Ab1FGQbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 12:31:09 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-7.tower-160.messagelabs.com!1307464267!25009065!7
X-StarScan-Version: 6.2.17; banners=-,-,-
X-Originating-IP: [216.166.12.98]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Joe Perches <joe@perches.com>, Jiri Kosina <trivial@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 7 Jun 2011 11:31:06 -0500
Subject: RE: [PATCH] treewide: Convert uses of struct resource * to
 resource_size(ptr)
Thread-Topic: [PATCH] treewide: Convert uses of struct resource * to
 resource_size(ptr)
Thread-Index: AcwkruaoVkwNIxP2QoSFuSpqo2cYswAgFAEg
Message-ID: <ADE657CA350FB648AAC2C43247A983F001F3820B7E27@AUSP01VMBX24.collaborationhost.net>
References: <201106061349.00474.hartleys@visionengravers.com>
	 <1307397174.4994.26.camel@Joe-Laptop>
	 <ADE657CA350FB648AAC2C43247A983F001F3820B7C78@AUSP01VMBX24.collaborationhost.net>
 <1307408678.4994.46.camel@Joe-Laptop>
In-Reply-To: <1307408678.4994.46.camel@Joe-Laptop>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p57GVKvr014707

On Monday, June 06, 2011 6:05 PM, Joe Perches wrote:
> 
> Done via coccinelle script:
> 
> struct resource *ptr;
> @@
> 
> - ptr->end - ptr->start + 1
> + resource_size(ptr)
> 
> Mostly uncompiled, not enough cross-compilers.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
> 
>> I think most of the offenders were caught back in late 2009.
> 
> There are quite a few left...

[...]

>  arch/arm/plat-mxc/pwm.c                    |    8 ++++----

No reply on my patch for this one.

>  drivers/char/hw_random/timeriomem-rng.c    |    2 +-

Matt Mackall already acked my patch for this one.  Not sure if anyone
picked it up and applied it.

[...]

>  drivers/dma/at_hdmac.c                     |    4 ++--
>  drivers/dma/ipu/ipu_idmac.c                |    6 ++----

I think Vinod Koul already applied my patches for these two.

>  drivers/dma/mv_xor.c                       |    5 ++---
>  drivers/gpio/vr41xx_giu.c                  |    2 +-

No reply on my patches for these.

[...]

>  drivers/misc/atmel_pwm.c                   |    2 +-

And no reply on my patch for this one.

Your treewide patch can be used instead of my individual patches if it's
easier/cleaner.

Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

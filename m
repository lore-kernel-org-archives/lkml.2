Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386Ab1ITRoF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 13:44:05 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:60851 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320Ab1ITRoE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 13:44:04 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-15.tower-127.messagelabs.com!1316540634!32224669!26
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.3.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linus Walleij <linus.walleij@stericsson.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: Linus Walleij <linus.walleij@linaro.org>, Lee Jones <lee.jones@linaro.org>,
        Ryan Mallon <rmallon@gmail.com>
Date: Tue, 20 Sep 2011 12:43:50 -0500
Subject: RE: [PATCH v2] mach-ep93xx: break out GPIO driver specifics
Thread-Topic: [PATCH v2] mach-ep93xx: break out GPIO driver specifics
Thread-Index: Acx3cUcwPwElrj+BQYGR1r+XGtG6RgAS2/Tg
Message-ID: <ADE657CA350FB648AAC2C43247A983F001F39DAED82F@AUSP01VMBX24.collaborationhost.net>
References: <1316508132-20020-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1316508132-20020-1-git-send-email-linus.walleij@stericsson.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, September 20, 2011 1:42 AM, Linus Walleij wrote:
>
> From: Linus Walleij <linus.walleij@linaro.org>
>
> The <mach/gpio.h> file is included from upper directories
> and deal with generic GPIO and gpiolib stuff. Break out the
> platform and driver specific defines and functions into its own
> header file.
>
> Cc: Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Ryan Mallon <rmallon@gmail.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> ChangeLog v1->v2:
> - Move the irq_to_gpio() into the driver since it was the only
>   thing actually using it, as a result the ep93xx gpio.h
>   is trivial and becomes empty.
> - Putting this into the patch tracker as 7042/2 soon-ish.
> ---
>  arch/arm/mach-ep93xx/core.c                     |    1 +
>  arch/arm/mach-ep93xx/edb93xx.c                  |    1 +
>  arch/arm/mach-ep93xx/include/mach/gpio-ep93xx.h |  100 +++++++++++++++++++++
>  arch/arm/mach-ep93xx/include/mach/gpio.h        |  105 -----------------------
>  arch/arm/mach-ep93xx/simone.c                   |    2 +-
>  arch/arm/mach-ep93xx/snappercl15.c              |    2 +-
>  drivers/gpio/gpio-ep93xx.c                      |    3 +
>  7 files changed, 107 insertions(+), 107 deletions(-)
>  create mode 100644 arch/arm/mach-ep93xx/include/mach/gpio-ep93xx.h

Acked-by: H Hartley Sweeten <hsweeten@visionengravers.com>

Thanks!
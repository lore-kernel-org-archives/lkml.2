Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960Ab2IJJxr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 05:53:47 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:50117 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355Ab2IJJxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 05:53:46 -0400
MIME-Version: 1.0
In-Reply-To: <1347016499-29354-7-git-send-email-lee.jones@linaro.org>
References: <1347016499-29354-1-git-send-email-lee.jones@linaro.org>
	<1347016499-29354-7-git-send-email-lee.jones@linaro.org>
Date: Mon, 10 Sep 2012 02:53:45 -0700
Message-ID: <CACRpkdbs9_hLB9c7WbWeR_6+Le4Svzc9Y5wTNVebOiRDB-o33g@mail.gmail.com>
Subject: Re: [PATCH 06/19] ARM: ux500: Add nodes for the MSP into the HREF
 Device Tree
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 7, 2012 at 1:14 PM, Lee Jones <lee.jones@linaro.org> wrote:

> This patch enables the two important MSP devices for ST-Ericsson's
> hardware reference development board.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  arch/arm/boot/dts/hrefv60plus.dts |    8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/arch/arm/boot/dts/hrefv60plus.dts b/arch/arm/boot/dts/hrefv60plus.dts
> index 62b2ac1..4f0aee8 100644
> --- a/arch/arm/boot/dts/hrefv60plus.dts
> +++ b/arch/arm/boot/dts/hrefv60plus.dts
> @@ -77,5 +77,13 @@
>
>                         status = "okay";
>                 };
> +
> +               msp1: msp@80124000 {
> +                       status = "okay";
> +               };
> +
> +               msp3: msp@80125000 {
> +                       status = "okay";
> +               };
>         };
>  };

Does this really "enable" the MSPs as the title claims?

Aren's there any kind of bindings needed, not even a
register base?

Yours,
Linus Walleij

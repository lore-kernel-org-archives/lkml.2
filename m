Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347Ab2IJJ4W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 05:56:22 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:34059 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315Ab2IJJ4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 05:56:21 -0400
MIME-Version: 1.0
In-Reply-To: <1347016499-29354-8-git-send-email-lee.jones@linaro.org>
References: <1347016499-29354-1-git-send-email-lee.jones@linaro.org>
	<1347016499-29354-8-git-send-email-lee.jones@linaro.org>
Date: Mon, 10 Sep 2012 02:56:20 -0700
Message-ID: <CACRpkdbh5BFmHp4uurmWfBExUKD0GDJCOHGp8kJCu2tReTWKWA@mail.gmail.com>
Subject: Re: [PATCH 07/19] ARM: ux500: Add all encompassing sound node to the
 HREF Device Tree
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>, Ola LILJA2 <ola.o.lilja@stericsson.com>,
        Roger NILSSON1 <roger.xr.nilsson@stericsson.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 7, 2012 at 1:14 PM, Lee Jones <lee.jones@linaro.org> wrote:

> This is where we link together all of the SoC sound components for
> a given platform. This all encompassing sound node is only found
> in the very lowest hierarchical DTS file, since the component mix may
> well change from board variant to board variant.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  arch/arm/boot/dts/hrefv60plus.dts |    7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/arch/arm/boot/dts/hrefv60plus.dts b/arch/arm/boot/dts/hrefv60plus.dts
> index 4f0aee8..d8ed29e 100644
> --- a/arch/arm/boot/dts/hrefv60plus.dts
> +++ b/arch/arm/boot/dts/hrefv60plus.dts
> @@ -78,6 +78,13 @@
>                         status = "okay";
>                 };
>
> +               sound {
> +                       compatible = "stericsson,snd-soc-mop500";
> +
> +                       stericsson,cpu-dai = <&msp1 &msp3>;
> +                       stericsson,audio-codec = <&codec>;

Where is this codec coming from?

It's certainly not in the linux-next tree...

This is another of these patches that I prefer if Ola
or Roger or even Mark could comment on, I really don't know
too much about ASoC DT bindings...

Yours,
Linus Walleij

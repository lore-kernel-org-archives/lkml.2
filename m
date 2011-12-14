Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758199Ab1LNVkP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 16:40:15 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:60599 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755505Ab1LNVkM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 16:40:12 -0500
MIME-Version: 1.0
In-Reply-To: <1323876538-20406-10-git-send-email-robherring2@gmail.com>
References: <1323876538-20406-1-git-send-email-robherring2@gmail.com> <1323876538-20406-10-git-send-email-robherring2@gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 14 Dec 2011 14:39:51 -0700
X-Google-Sender-Auth: WBudR5_teYXiqzDmcADczKlzZ2A
Message-ID: <CACxGe6vDsk9W0Wnr02RhbfKaWWFXHG5vQD_+bKT5h0H88UAOgw@mail.gmail.com>
Subject: Re: [PATCH 9/9] ARM: highbank: add interrupt properties to gpio nodes
To: Rob Herring <robherring2@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, shawn.guo@freescale.com,
        Kukjin Kim <kgene.kim@samsung.com>, Kevin Hilman <khilman@ti.com>,
        Tony Lindgren <tony@atomide.com>, Barry Song <baohua.song@csr.com>,
        Linus Walleij <linus.ml.walleij@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 8:28 AM, Rob Herring <robherring2@gmail.com> wrote:
> From: Rob Herring <rob.herring@calxeda.com>
>
> Add interrupt-controller properties to pl061 gpio nodes so gpio lines can
> function as interrupts.
>
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>

Acked-by: Grant Likely <grant.likely@secretlab.ca>

> ---
>  arch/arm/boot/dts/highbank.dts |    9 ++++++++-
>  1 files changed, 8 insertions(+), 1 deletions(-)
>
> diff --git a/arch/arm/boot/dts/highbank.dts b/arch/arm/boot/dts/highbank.dts
> index aeb1a75..dfe2b49 100644
> --- a/arch/arm/boot/dts/highbank.dts
> +++ b/arch/arm/boot/dts/highbank.dts
> @@ -89,7 +89,6 @@
>                        #size-cells = <0>;
>                        #address-cells = <1>;
>                        interrupt-controller;
> -                       interrupt-parent;
>                        reg = <0xfff11000 0x1000>,
>                              <0xfff10100 0x100>;
>                };
> @@ -129,6 +128,8 @@
>                        #gpio-cells = <2>;
>                        compatible = "arm,pl061", "arm,primecell";
>                        gpio-controller;
> +                       interrupt-controller;
> +                       #interrupt-cells = <2>;
>                        reg = <0xfff30000 0x1000>;
>                        interrupts = <0 14 4>;
>                };
> @@ -137,6 +138,8 @@
>                        #gpio-cells = <2>;
>                        compatible = "arm,pl061", "arm,primecell";
>                        gpio-controller;
> +                       interrupt-controller;
> +                       #interrupt-cells = <2>;
>                        reg = <0xfff31000 0x1000>;
>                        interrupts = <0 15 4>;
>                };
> @@ -145,6 +148,8 @@
>                        #gpio-cells = <2>;
>                        compatible = "arm,pl061", "arm,primecell";
>                        gpio-controller;
> +                       interrupt-controller;
> +                       #interrupt-cells = <2>;
>                        reg = <0xfff32000 0x1000>;
>                        interrupts = <0 16 4>;
>                };
> @@ -153,6 +158,8 @@
>                        #gpio-cells = <2>;
>                        compatible = "arm,pl061", "arm,primecell";
>                        gpio-controller;
> +                       interrupt-controller;
> +                       #interrupt-cells = <2>;
>                        reg = <0xfff33000 0x1000>;
>                        interrupts = <0 17 4>;
>                };
> --
> 1.7.5.4
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.

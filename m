Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559Ab2G0XX5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 19:23:57 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:58574 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184Ab2G0XX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 19:23:56 -0400
MIME-Version: 1.0
In-Reply-To: <1343112660-12245-3-git-send-email-blogic@openwrt.org>
References: <1343112660-12245-1-git-send-email-blogic@openwrt.org>
	<1343112660-12245-3-git-send-email-blogic@openwrt.org>
Date: Sat, 28 Jul 2012 01:23:55 +0200
Message-ID: <CACRpkdYP8PdcnS2h_-+n9ZdBmMuBPUv9so9WsUyS-X5rMz1qsQ@mail.gmail.com>
Subject: Re: [PATCH 3/6] OF: pinctrl: MIPS: lantiq: adds support for FALCON SoC
From: Linus Walleij <linus.walleij@linaro.org>
To: John Crispin <blogic@openwrt.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Thomas Langer <thomas.langer@lantiq.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2012 at 8:50 AM, John Crispin <blogic@openwrt.org> wrote:

> Implement support for pinctrl on lantiq/falcon socs. The FALCON has 5 banks
> of up to 32 pins.
>
> Signed-off-by: John Crispin <blogic@openwrt.org>
> Signed-off-by: Thomas Langer <thomas.langer@lantiq.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: devicetree-discuss@lists.ozlabs.org
> Cc: linux-kernel@vger.kernel.org

No big issues and looking really sweet so:
Acked-by: Linus Walleij <linus.walleij@linaro.org>

> --- a/arch/mips/lantiq/Kconfig
> +++ b/arch/mips/lantiq/Kconfig
> @@ -20,6 +20,7 @@ config SOC_XWAY
>
>  config SOC_FALCON
>         bool "FALCON"
> +       select PINCTRL_FALCON

I think you need to add "select PINCTRL" above "select PINCTRL_FALCON"
for this to work.

Atleast I had to do that in the past to get things working.

Yours,
Linus Walleij

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551Ab3AHUSg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 15:18:36 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:64931 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868Ab3AHUSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 15:18:35 -0500
MIME-Version: 1.0
In-Reply-To: <1357592400-18117-1-git-send-email-seanpaul@chromium.org>
References: <1357592400-18117-1-git-send-email-seanpaul@chromium.org>
From: Sean Paul <seanpaul@chromium.org>
Date: Tue, 8 Jan 2013 15:18:11 -0500
Message-ID: <CAOw6vbJRoFtrhhhf4t0KDu72TieKBQ0LDvgPVfi7Q4OwQUTqDw@mail.gmail.com>
Subject: Re: [PATCH] ARM: dts: exynos5250: Set HDMI version to v1.4
To: linux-arm-kernel@lists.infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-samsung-soc@vger.kernel.org
Cc: thomas.abraham@linaro.org, "kgene.kim" <kgene.kim@samsung.com>,
        Sean Paul <seanpaul@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 7, 2013 at 4:00 PM, Sean Paul <seanpaul@chromium.org> wrote:
> Set the HDMI version to v1.4 for all exynos5250 targets. This property
> was previously being inferred by the existence of the hdmi node.
>
> Signed-off-by: Sean Paul <seanpaul@chromium.org>
> ---

The patch adding the property has churned a bit from
devicetree-discuss reviews. I'll upload this again after it's settled.

Please drop.

Sean

>  arch/arm/boot/dts/exynos5250.dtsi |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
> index 2e3b6ef..9fb6845 100644
> --- a/arch/arm/boot/dts/exynos5250.dtsi
> +++ b/arch/arm/boot/dts/exynos5250.dtsi
> @@ -576,6 +576,7 @@
>                 compatible = "samsung,exynos5-hdmi";
>                 reg = <0x14530000 0x100000>;
>                 interrupts = <0 95 0>;
> +               samsung,supports-hdmi-1.4;
>         };
>
>         mixer {
> --
> 1.7.7.3
>

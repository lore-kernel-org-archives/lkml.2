Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751307Ab2KGGE6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 01:04:58 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:36125 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768Ab2KGGE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 01:04:57 -0500
MIME-Version: 1.0
In-Reply-To: <1352266628.7588.1.camel@phoenix>
References: <1352266628.7588.1.camel@phoenix>
Date: Wed, 7 Nov 2012 14:04:57 +0800
Message-ID: <CAP1dx+zMZe0rnmOEBpo4FYB_zskiB3x0BFjqM=NoqXS7XvOMxA@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: Staticize pinconf_ops
From: Dong Aisheng <dong.aisheng@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Simon Arlott <simon@fire.lp0.eu>, John Crispin <blogic@openwrt.org>,
        Shawn Guo <shawn.guo@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 November 2012 13:37, Axel Lin <axel.lin@ingics.com> wrote:
> They are not referenced outside respective driver.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> Cc: Simon Arlott <simon@fire.lp0.eu>
> Cc: John Crispin <blogic@openwrt.org>
> Cc: Dong Aisheng <dong.aisheng@linaro.org>
> Cc: Shawn Guo <shawn.guo@linaro.org>
> Cc: Stephen Warren <swarren@wwwdotorg.org>
> ---
>  drivers/pinctrl/pinctrl-at91.c    |    2 +-
>  drivers/pinctrl/pinctrl-bcm2835.c |    2 +-
>  drivers/pinctrl/pinctrl-falcon.c  |    2 +-
>  drivers/pinctrl/pinctrl-imx.c     |    2 +-

For imx,
Acked-by: Dong Aisheng <dong.aisheng@linaro.org>

Regards
Dong Aisheng

>  drivers/pinctrl/pinctrl-mxs.c     |    2 +-
>  drivers/pinctrl/pinctrl-tegra.c   |    2 +-
>  drivers/pinctrl/pinctrl-xway.c    |    2 +-
>  7 files changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c
> index b9e2cbd..8490a55 100644
> --- a/drivers/pinctrl/pinctrl-at91.c
> +++ b/drivers/pinctrl/pinctrl-at91.c
> @@ -665,7 +665,7 @@ static void at91_pinconf_group_dbg_show(struct pinctrl_dev *pctldev,
>  {
>  }
>
> -struct pinconf_ops at91_pinconf_ops = {
> +static struct pinconf_ops at91_pinconf_ops = {
>         .pin_config_get                 = at91_pinconf_get,
>         .pin_config_set                 = at91_pinconf_set,
>         .pin_config_dbg_show            = at91_pinconf_dbg_show,
> diff --git a/drivers/pinctrl/pinctrl-bcm2835.c b/drivers/pinctrl/pinctrl-bcm2835.c
> index 7e9be18..9a963ed 100644
> --- a/drivers/pinctrl/pinctrl-bcm2835.c
> +++ b/drivers/pinctrl/pinctrl-bcm2835.c
> @@ -916,7 +916,7 @@ static int bcm2835_pinconf_set(struct pinctrl_dev *pctldev,
>         return 0;
>  }
>
> -struct pinconf_ops bcm2835_pinconf_ops = {
> +static struct pinconf_ops bcm2835_pinconf_ops = {
>         .pin_config_get = bcm2835_pinconf_get,
>         .pin_config_set = bcm2835_pinconf_set,
>  };
> diff --git a/drivers/pinctrl/pinctrl-falcon.c b/drivers/pinctrl/pinctrl-falcon.c
> index ee73059..8ed20e8 100644
> --- a/drivers/pinctrl/pinctrl-falcon.c
> +++ b/drivers/pinctrl/pinctrl-falcon.c
> @@ -322,7 +322,7 @@ static void falcon_pinconf_group_dbg_show(struct pinctrl_dev *pctrldev,
>  {
>  }
>
> -struct pinconf_ops falcon_pinconf_ops = {
> +static struct pinconf_ops falcon_pinconf_ops = {
>         .pin_config_get                 = falcon_pinconf_get,
>         .pin_config_set                 = falcon_pinconf_set,
>         .pin_config_group_get           = falcon_pinconf_group_get,
> diff --git a/drivers/pinctrl/pinctrl-imx.c b/drivers/pinctrl/pinctrl-imx.c
> index 63866d9..f3d2384 100644
> --- a/drivers/pinctrl/pinctrl-imx.c
> +++ b/drivers/pinctrl/pinctrl-imx.c
> @@ -397,7 +397,7 @@ static void imx_pinconf_group_dbg_show(struct pinctrl_dev *pctldev,
>         }
>  }
>
> -struct pinconf_ops imx_pinconf_ops = {
> +static struct pinconf_ops imx_pinconf_ops = {
>         .pin_config_get = imx_pinconf_get,
>         .pin_config_set = imx_pinconf_set,
>         .pin_config_dbg_show = imx_pinconf_dbg_show,
> diff --git a/drivers/pinctrl/pinctrl-mxs.c b/drivers/pinctrl/pinctrl-mxs.c
> index 4ba4636..3e7d4d6 100644
> --- a/drivers/pinctrl/pinctrl-mxs.c
> +++ b/drivers/pinctrl/pinctrl-mxs.c
> @@ -319,7 +319,7 @@ static void mxs_pinconf_group_dbg_show(struct pinctrl_dev *pctldev,
>                 seq_printf(s, "0x%lx", config);
>  }
>
> -struct pinconf_ops mxs_pinconf_ops = {
> +static struct pinconf_ops mxs_pinconf_ops = {
>         .pin_config_get = mxs_pinconf_get,
>         .pin_config_set = mxs_pinconf_set,
>         .pin_config_group_get = mxs_pinconf_group_get,
> diff --git a/drivers/pinctrl/pinctrl-tegra.c b/drivers/pinctrl/pinctrl-tegra.c
> index 7da0b37..f7fe91e 100644
> --- a/drivers/pinctrl/pinctrl-tegra.c
> +++ b/drivers/pinctrl/pinctrl-tegra.c
> @@ -660,7 +660,7 @@ static void tegra_pinconf_config_dbg_show(struct pinctrl_dev *pctldev,
>  }
>  #endif
>
> -struct pinconf_ops tegra_pinconf_ops = {
> +static struct pinconf_ops tegra_pinconf_ops = {
>         .pin_config_get = tegra_pinconf_get,
>         .pin_config_set = tegra_pinconf_set,
>         .pin_config_group_get = tegra_pinconf_group_get,
> diff --git a/drivers/pinctrl/pinctrl-xway.c b/drivers/pinctrl/pinctrl-xway.c
> index b9bcaec..ad90984 100644
> --- a/drivers/pinctrl/pinctrl-xway.c
> +++ b/drivers/pinctrl/pinctrl-xway.c
> @@ -522,7 +522,7 @@ static int xway_pinconf_set(struct pinctrl_dev *pctldev,
>         return 0;
>  }
>
> -struct pinconf_ops xway_pinconf_ops = {
> +static struct pinconf_ops xway_pinconf_ops = {
>         .pin_config_get = xway_pinconf_get,
>         .pin_config_set = xway_pinconf_set,
>  };
> --
> 1.7.9.5
>
>
>

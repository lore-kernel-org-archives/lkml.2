Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751309Ab1ADCC0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 21:02:26 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:34999 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab1ADCCZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 21:02:25 -0500
MIME-Version: 1.0
In-Reply-To: <1294070258.3320.4.camel@phoenix>
References: <1294070258.3320.4.camel@phoenix>
Date: Tue, 4 Jan 2011 10:02:24 +0800
Message-ID: <AANLkTim-v0SesMCW-Nu=PX5Qzoe025dgwdfhjDzMNEgY@mail.gmail.com>
Subject: Re: [PATCH] regulator: Assign return value of mc13xxx_reg_rmw to ret
From: Yong Shen <yong.shen@linaro.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Yong Shen <yong.shen@linaro.org>

On Mon, Jan 3, 2011 at 11:57 PM, Axel Lin <axel.lin@gmail.com> wrote:
> Otherwise, we will not return error if write to MC13892_SWITCHERS5 failed.
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/regulator/mc13892-regulator.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/regulator/mc13892-regulator.c b/drivers/regulator/mc13892-regulator.c
> index 16a0532..1b8f739 100644
> --- a/drivers/regulator/mc13892-regulator.c
> +++ b/drivers/regulator/mc13892-regulator.c
> @@ -550,7 +550,7 @@ static int __devinit mc13892_regulator_probe(struct platform_device *pdev)
>                if (ret)
>                        goto err_free;
>
> -               mc13xxx_reg_rmw(mc13892, MC13892_SWITCHERS5,
> +               ret = mc13xxx_reg_rmw(mc13892, MC13892_SWITCHERS5,
>                        MC13892_SWITCHERS5_SW3MODE_M |
>                        MC13892_SWITCHERS5_SW4MODE_M,
>                        MC13892_SWITCHERS5_SW3MODE_AUTO |
> --
> 1.7.0.4
>
>
>
>

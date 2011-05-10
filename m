Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932454Ab1EJIM0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 04:12:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60272 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932401Ab1EJIMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 04:12:24 -0400
Date: Tue, 10 May 2011 10:12:22 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Wanlong Gao <wanlong.gao@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, lrg@slimlogic.co.uk
Subject: Re: [PATCH] drivers:regulator:change debug statement be consistent
 with the style of the rest.
In-Reply-To: <4DAA3A25.30501@gmail.com>
Message-ID: <alpine.LNX.2.00.1105101011550.28291@pobox.suse.cz>
References: <1302968543-3150-1-git-send-email-wanlong.gao@gmail.com> <20110416175440.GD25811@opensource.wolfsonmicro.com> <4DAA3A25.30501@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Apr 2011, Wanlong Gao wrote:

> 
> 
> change the "mc13783_regulator_probe" string in the function
> "mc13783_regulator_probe"
> to "__func__" for the debug statement be consistent with the style of the rest
> of
> the file.
> 
> Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> 
> ---
>  drivers/regulator/mc13783-regulator.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/regulator/mc13783-regulator.c
> b/drivers/regulator/mc13783-regulator.c
> index 23249cb..b8a00c7 100644
> --- a/drivers/regulator/mc13783-regulator.c
> +++ b/drivers/regulator/mc13783-regulator.c
> @@ -341,7 +341,7 @@ static int __devinit mc13783_regulator_probe(struct
> platform_device *pdev)
>         struct mc13783_regulator_init_data *init_data;
>         int i, ret;
> 
> -       dev_dbg(&pdev->dev, "mc13783_regulator_probe id %d\n", pdev->id);
> +       dev_dbg(&pdev->dev, "%s id %d\n", __func__, pdev->id);
> 
>         priv = kzalloc(sizeof(*priv) +
>                         pdata->num_regulators * sizeof(priv->regulators[0]),

Applied.

BTW, your mailer is damaging the in-line patches. I have fixed this now, 
but please fix that for your future submissions.

Thanks,

-- 
Jiri Kosina
SUSE Labs

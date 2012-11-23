Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759102Ab2KWJfI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 04:35:08 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:56310 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759039Ab2KWJfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 04:35:05 -0500
MIME-Version: 1.0
In-Reply-To: <1352894295-14339-4-git-send-email-alban.bedel@avionic-design.de>
References: <1352894295-14339-1-git-send-email-alban.bedel@avionic-design.de>
	<1352894295-14339-4-git-send-email-alban.bedel@avionic-design.de>
Date: Fri, 23 Nov 2012 07:35:04 -0200
Message-ID: <CAAAP30E6aFbeLq3uf8t2oiepaqouFRWtTt=Uc+TRir36acNKSA@mail.gmail.com>
Subject: Re: [PATCH 3/3] pwm: lpc32xx - Set the chip base for dynamic allocation
From: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
To: Alban Bedel <alban.bedel@avionic-design.de>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        linux-kernel@vger.kernel.org, Roland Stigge <stigge@antcom.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2012 at 9:58 AM, Alban Bedel
<alban.bedel@avionic-design.de> wrote:
> Signed-off-by: Alban Bedel <alban.bedel@avionic-design.de>

Acked-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>

> ---
>  drivers/pwm/pwm-lpc32xx.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/pwm/pwm-lpc32xx.c b/drivers/pwm/pwm-lpc32xx.c
> index f45ce2c..3e63689 100644
> --- a/drivers/pwm/pwm-lpc32xx.c
> +++ b/drivers/pwm/pwm-lpc32xx.c
> @@ -121,6 +121,7 @@ static int lpc32xx_pwm_probe(struct platform_device *pdev)
>         lpc32xx->chip.dev = &pdev->dev;
>         lpc32xx->chip.ops = &lpc32xx_pwm_ops;
>         lpc32xx->chip.npwm = 2;
> +       lpc32xx->chip.base = -1;
>
>         ret = pwmchip_add(&lpc32xx->chip);
>         if (ret < 0) {
> --
> 1.7.0.4
>

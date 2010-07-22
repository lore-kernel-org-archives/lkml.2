Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603Ab0GVFeV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 01:34:21 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:39129 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078Ab0GVFeS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 01:34:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=oPTZs/7ZRiHCR+ohvEFknQyaZQlJx5riUhE7UHQt6yHGG9IB79kzazmrYDv6UQA9g+
         HQUcxXVwijJraeXDFNW6Z5rZzguTkoYK+OfTSaJCETQswl2YDorHTd7Hc9y2rdO7PFnb
         UeBYD3TxajJNB9aNqVyaNlJaCHN0PD7DSmTJ8=
MIME-Version: 1.0
In-Reply-To: <4C431211.6030706@gmail.com>
References: <4C431211.6030706@gmail.com>
Date: Thu, 22 Jul 2010 13:34:17 +0800
Message-ID: <AANLkTil5hsZYCWaMekzPkLfEC0_wxmBWfT3jj0IC5j6f@mail.gmail.com>
Subject: Re: [PATCH] keypad/nuc900: change keypad driver name from 
	'nuc900-keypad' to 'nuc900-kpi'
From: Wan ZongShun <mcuos.com@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry,

Can it be applied?

Thanks!

> Hi Dmitry,
>
> I ever changed the keypad platform device name from 'nuc900-keypad' to
> 'nuc900-kpi', but I forget to modify the related keypad driver name,so
> the keypad driver does not work,I have to send the patch to fix this issue.
>
> Signed-off-by: Wan ZongShun <mcuos.com@gmail.com>
> ---
>  drivers/input/keyboard/w90p910_keypad.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/input/keyboard/w90p910_keypad.c b/drivers/input/keyboard/w90p910_keypad.c
> index 4ef764c..ee2bf6b 100644
> --- a/drivers/input/keyboard/w90p910_keypad.c
> +++ b/drivers/input/keyboard/w90p910_keypad.c
> @@ -258,7 +258,7 @@ static struct platform_driver w90p910_keypad_driver = {
>        .probe          = w90p910_keypad_probe,
>        .remove         = __devexit_p(w90p910_keypad_remove),
>        .driver         = {
> -               .name   = "nuc900-keypad",
> +               .name   = "nuc900-kpi",
>                .owner  = THIS_MODULE,
>        },
>  };
> --
> 1.6.3.3
>



-- 
*linux-arm-kernel mailing list
mail addr:linux-arm-kernel@lists.infradead.org
you can subscribe by:
http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

* linux-arm-NUC900 mailing list
mail addr:NUC900@googlegroups.com
main web: https://groups.google.com/group/NUC900
you can subscribe it by sending me mail:
mcuos.com@gmail.com

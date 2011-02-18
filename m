Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899Ab1BRGUY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 01:20:24 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:64723 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322Ab1BRGUW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 01:20:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=SkyDZcqsRG5bNnr28hHf8g9r1yBAaZmR2icpPPB5v1rPRv3btRDgfl6vMAPyMvZgW/
         OJAmg9uk4xoZE70YNu3fOlwj76iCfNWwvyPjKFHMhtEr+zfFAJCUNaurK7LHwdCmyI+3
         nEYCUyq9TeXgmoD8WYe/I6mbOL0s3cfE9NZ/k=
MIME-Version: 1.0
In-Reply-To: <1297679802-24669-1-git-send-email-dbaryshkov@gmail.com>
References: <1297679802-24669-1-git-send-email-dbaryshkov@gmail.com>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Fri, 18 Feb 2011 14:20:01 +0800
Message-ID: <AANLkTi=Fi_W99Nd6ZG9tp+jPqe1iOHL-rddwBVXp0ZuW@mail.gmail.com>
Subject: Re: [PATCH] tosa-bt: drop setting LED trigger name, as it's
 unsupported now
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Stephen Hemminger <shemminger@vyatta.com>,
        "John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 14, 2011 at 6:36 PM, Dmitry Eremin-Solenikov
<dbaryshkov@gmail.com> wrote:
> Since 2e48928d8a0f38c1b5c81eb3f1294de8a6382c68 it's no longer possible to set
> the name of the LED trigger for RFKILL events. Drop respective code from tosa-bt.c
>
> Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> Cc: Stephen Hemminger <shemminger@vyatta.com>
> Cc: John W. Linville <linville@tuxdriver.com>

Applied to 'fix'.

I hope there is no existing user of this trigger name, but you know
better than I do.

> ---
>  arch/arm/mach-pxa/tosa-bt.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm/mach-pxa/tosa-bt.c b/arch/arm/mach-pxa/tosa-bt.c
> index c31e601..b9b1e5c 100644
> --- a/arch/arm/mach-pxa/tosa-bt.c
> +++ b/arch/arm/mach-pxa/tosa-bt.c
> @@ -81,8 +81,6 @@ static int tosa_bt_probe(struct platform_device *dev)
>                goto err_rfk_alloc;
>        }
>
> -       rfkill_set_led_trigger_name(rfk, "tosa-bt");
> -
>        rc = rfkill_register(rfk);
>        if (rc)
>                goto err_rfkill;
> --
> 1.7.2.3
>
>

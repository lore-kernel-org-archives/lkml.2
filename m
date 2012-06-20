Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540Ab2FTFY1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 01:24:27 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:36680 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899Ab2FTFY0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 01:24:26 -0400
MIME-Version: 1.0
In-Reply-To: <1340130159-10408-1-git-send-email-devendra.aaru@gmail.com>
References: <1340130159-10408-1-git-send-email-devendra.aaru@gmail.com>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Wed, 20 Jun 2012 13:24:05 +0800
X-Google-Sender-Auth: ZFN7D6RgKcAtcU6cluAR0sb8NIs
Message-ID: <CAK5ve-+7upSnKLB5DkLgBFTQgiKpXAG1uKWK=U45Z94fT864FA@mail.gmail.com>
Subject: Re: [PATCH] leds: [trivial]Remove unnecesary return
To: Devendra Naga <devendra.aaru@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>, Jiri Kosina <trivial@kernel.org>,
        linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2012 at 2:22 AM, Devendra Naga <devendra.aaru@gmail.com> wrote:
> the ret is got the status returned by the
> led_classdev_register, returning ret if the
> led_classdev_register fails and returning 0
> if the led_classdev_register success, can be done
> by doing just "return ret" at the end.
>
> Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>

Thanks, applied to my for-next branch.

-Bryan

> ---
>
> Tested by build with the gcc linaro (arm-linux-gnueabihf) (4.7.1).
>
>  drivers/leds/leds-s3c24xx.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/leds/leds-s3c24xx.c b/drivers/leds/leds-s3c24xx.c
> index bd0a5ed..e6ee105 100644
> --- a/drivers/leds/leds-s3c24xx.c
> +++ b/drivers/leds/leds-s3c24xx.c
> @@ -106,10 +106,9 @@ static int s3c24xx_led_probe(struct platform_device *dev)
>        if (ret < 0) {
>                dev_err(&dev->dev, "led_classdev_register failed\n");
>                kfree(led);
> -               return ret;
>        }
>
> -       return 0;
> +       return ret;
>  }
>
>  static struct platform_driver s3c24xx_led_driver = {
> --
> 1.7.9.5



-- 
Bryan Wu <bryan.wu@canonical.com>
Kernel Developer    +86.186-168-78255 Mobile
Canonical Ltd.      www.canonical.com
Ubuntu - Linux for human beings | www.ubuntu.com

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755648Ab2FDCvm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 22:51:42 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:39076 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755589Ab2FDCvl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 22:51:41 -0400
MIME-Version: 1.0
In-Reply-To: <1338725513-3156-1-git-send-email-ahiliation@yahoo.co.in>
References: <1338725513-3156-1-git-send-email-ahiliation@yahoo.co.in>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Mon, 4 Jun 2012 10:51:20 +0800
X-Google-Sender-Auth: HXnjEcK0AWySFz7OC5sY4ppfcS4
Message-ID: <CAK5ve-JkU-NZzDbUG8Y3Pr3HL3Xts_T6f4=b6ZyzoYRAFGXCjQ@mail.gmail.com>
Subject: Re: [PATCH]drivers:leds:fixed a coding style issue.
To: Jeffrin Jose <ahiliation@yahoo.co.in>
Cc: rpurdie@rpsys.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 3, 2012 at 8:11 PM, Jeffrin Jose <ahiliation@yahoo.co.in> wrote:
> Fixed a coding style issue relating to trailing
> white space error found by checkpatch.pl tool in drivers/leds/led-class.c
>
> Signed-off-by: Jeffrin Jose <ahiliation@yahoo.co.in>

OK, applied in my fixes-for-3.5 branch and changed the subject to
"leds: fixed a coding style issue."

Thanks,
-Bryan

> ---
>  drivers/leds/led-class.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
> index 8ee92c8..e663e6f 100644
> --- a/drivers/leds/led-class.c
> +++ b/drivers/leds/led-class.c
> @@ -29,7 +29,7 @@ static void led_update_brightness(struct led_classdev *led_cdev)
>                led_cdev->brightness = led_cdev->brightness_get(led_cdev);
>  }
>
> -static ssize_t led_brightness_show(struct device *dev,
> +static ssize_t led_brightness_show(struct device *dev,
>                struct device_attribute *attr, char *buf)
>  {
>        struct led_classdev *led_cdev = dev_get_drvdata(dev);
> --
> 1.7.10
>



-- 
Bryan Wu <bryan.wu@canonical.com>
Kernel Developer    +86.186-168-78255 Mobile
Canonical Ltd.      www.canonical.com
Ubuntu - Linux for human beings | www.ubuntu.com

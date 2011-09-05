Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875Ab1IEUOt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 16:14:49 -0400
Received: from 93-97-173-237.zone5.bethere.co.uk ([93.97.173.237]:55978 "EHLO
	tim.rpsys.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753764Ab1IEUOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 16:14:34 -0400
Subject: Re: [PATCH 2/2] Documentation: leds-class: fix a typo
From: Richard Purdie <richard.purdie@linuxfoundation.org>
To: Bryan Wu <bryan.wu@canonical.com>
Cc: linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org, akpm <akpm@linux-foundation.org>
In-Reply-To: <1315249786-15387-2-git-send-email-bryan.wu@canonical.com>
References: <1315249786-15387-1-git-send-email-bryan.wu@canonical.com>
	 <1315249786-15387-2-git-send-email-bryan.wu@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 05 Sep 2011 20:52:46 +0100
Message-ID: <1315252366.1243.22.camel@ted>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-06 at 03:09 +0800, Bryan Wu wrote:
> Signed-off-by: Bryan Wu <bryan.wu@canonical.com>

Acked-by: Richard Purdie <rchard.purdie@linuxfoundation.org>

> ---
>  Documentation/leds/leds-class.txt |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/leds/leds-class.txt b/Documentation/leds/leds-class.txt
> index 4996586..79699c2 100644
> --- a/Documentation/leds/leds-class.txt
> +++ b/Documentation/leds/leds-class.txt
> @@ -61,8 +61,8 @@ Hardware accelerated blink of LEDs
>  Some LEDs can be programmed to blink without any CPU interaction. To
>  support this feature, a LED driver can optionally implement the
>  blink_set() function (see <linux/leds.h>). To set an LED to blinking,
> -however, it is better to use use the API function led_blink_set(),
> -as it will check and implement software fallback if necessary.
> +however, it is better to use the API function led_blink_set(), as it
> +will check and implement software fallback if necessary.
>  
>  To turn off blinking again, use the API function led_brightness_set()
>  as that will not just set the LED brightness but also stop any software



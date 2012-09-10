Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751278Ab2IJF3S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 01:29:18 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:46845 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750753Ab2IJF3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 01:29:15 -0400
Message-ID: <504D7A8E.1090005@xenotime.net>
Date: Sun, 09 Sep 2012 22:28:46 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: "G.Shark Jeong" <gshark.jeong@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Richard Purdie <rpurdie@rpsys.net>, Daniel Jeong <daniel.jeong@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] backlight: add new lm3639 backlight driver
References: <1347246964-28332-1-git-send-email-gshark.jeong@gmail.com>
In-Reply-To: <1347246964-28332-1-git-send-email-gshark.jeong@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2012 08:16 PM, G.Shark Jeong wrote:

> From: "G.Shark Jeong" <gshark.jeong@gmail.com>
> 
> This driver is a general version for LM3639 backlgiht driver chip of TI.
> 
> Put NEW_LEDS and LEDS_CLASS into Kconfig file to reduce additional configuration works in LEDs.
> 
> www.ti.com


eh?

> 
> Signed-off-by: G.Shark Jeong <gshark.jeong@gmail.com>


Linus has asked patch committers to use Reported-by when appropriate.

Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Acked-by: Randy Dunlap <rdunlap@xenotime.net>


> ---
>  drivers/video/backlight/Kconfig |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/video/backlight/Kconfig b/drivers/video/backlight/Kconfig
> index 2ed68bd..e6c78cd 100644
> --- a/drivers/video/backlight/Kconfig
> +++ b/drivers/video/backlight/Kconfig
> @@ -356,6 +356,8 @@ config BACKLIGHT_LM3639
>  	tristate "Backlight Driver for LM3639"
>  	depends on BACKLIGHT_CLASS_DEVICE && I2C
>  	select REGMAP_I2C
> +	select NEW_LEDS
> +	select LEDS_CLASS
>  	help
>  	  This supports TI LM3639 Backlight + 1.5A Flash LED Driver
>  



-- 
~Randy

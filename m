Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751264Ab0I1KpC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 06:45:02 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:62830 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787Ab0I1KpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 06:45:00 -0400
Message-ID: <4CA1C6C4.20504@mvista.com>
Date: Tue, 28 Sep 2010 14:43:16 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: Arun Murthy <arun.murthy@stericsson.com>
CC: lars@metafoo.de, akpm@linux-foundation.org, kernel@pengutronix.de,
        philipp.zabel@gmail.com, robert.jarzmik@free.fr, marek.vasut@gmail.com,
        eric.y.miao@gmail.com, rpurdie@rpsys.net, sameo@linux.intel.com,
        kgene.kim@samsung.com, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org, STEricsson_nomadik_linux@list.st.com
Subject: Re: [PATCH 3/7] leds: pwm: add a new element 'name' to platform data
References: <1285670134-18063-1-git-send-email-arun.murthy@stericsson.com> <1285670134-18063-4-git-send-email-arun.murthy@stericsson.com>
In-Reply-To: <1285670134-18063-4-git-send-email-arun.murthy@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 28-09-2010 14:35, Arun Murthy wrote:

> A new element 'name' is added to pwm led platform data structure.
> This is required to identify the pwm device.

> Signed-off-by: Arun Murthy<arun.murthy@stericsson.com>
> Acked-by: Linus Walleij<linus.walleij@stericsson.com>

[...]

> diff --git a/include/linux/leds_pwm.h b/include/linux/leds_pwm.h
> index 33a0711..7a847a0 100644
> --- a/include/linux/leds_pwm.h
> +++ b/include/linux/leds_pwm.h
> @@ -16,6 +16,7 @@ struct led_pwm {
>   struct led_pwm_platform_data {
>   	int			num_leds;
>   	struct led_pwm	*leds;
> +	char *name;
>   };

    Shouldn't '*name'be aligned, at least with '*leds'?

WBR, Sergei

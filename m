Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755781Ab2IJAL0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 20:11:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51647 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755269Ab2IJALY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 20:11:24 -0400
Message-ID: <504D301F.60209@gmail.com>
Date: Mon, 10 Sep 2012 09:11:11 +0900
From: gshark <gshark.jeong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        linux-next@vger.kernel.org, Daniel Jeong <daniel.jeong@ti.com>
Subject: Re: mmotm 2012-09-06-16-46 uploaded (drivers/video/backlight/lm3639_bl)
References: <20120906234735.1B54B20004E@hpza10.eem.corp.google.com> <504A93D3.7060203@xenotime.net>
In-Reply-To: <504A93D3.7060203@xenotime.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy.

LM3630/9 have the pins for led so these depend on BACKLIGHT_CLASS_DEVICE 
and I2C.
So we need to set LEDS_CLASS and NEW_LEDS.

I will put these two into driver/video/backlight/Kconfig file and patch 
it so that you don't need to do it.

2012년 09월 08일 09:39, Randy Dunlap 쓴 글:
> On 09/06/2012 04:47 PM, akpm@linux-foundation.org wrote:
>
>> The mm-of-the-moment snapshot 2012-09-06-16-46 has been uploaded to
>>
>>     http://www.ozlabs.org/~akpm/mmotm/
>>
>
> on x86_64:
>
> ERROR: "led_classdev_register" [drivers/video/backlight/lm3639_bl.ko] undefined!
> ERROR: "led_classdev_unregister" [drivers/video/backlight/lm3639_bl.ko] undefined!
>
> Full randconfig file is attached.
>



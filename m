Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205Ab2DXHiT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 03:38:19 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:50207 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754570Ab2DXHiS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 03:38:18 -0400
MIME-Version: 1.0
In-Reply-To: <20120423113425.GN24211@n2100.arm.linux.org.uk>
References: <1335180632-21381-1-git-send-email-linus.walleij@stericsson.com>
	<20120423113425.GN24211@n2100.arm.linux.org.uk>
Date: Tue, 24 Apr 2012 09:38:17 +0200
Message-ID: <CACRpkda=aUFyZ2M3wAWSNzuk4EwGNRbo-qqtxLA26PeRKRtTog@mail.gmail.com>
Subject: Re: [PATCH 5/9 v2] gpio/nomadik: use ioremap() instead of static mappings
From: Linus Walleij <linus.walleij@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Jonas Aberg <jonas.aberg@stericsson.com>,
        Philippe LANGLAIS <philippe.langlais@stericsson.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2012 at 1:34 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Mon, Apr 23, 2012 at 01:30:32PM +0200, Linus Walleij wrote:
>> diff --git a/drivers/gpio/gpio-nomadik.c b/drivers/gpio/gpio-nomadik.c
>> index 7b45d88..bddc3dd 100644
>> --- a/drivers/gpio/gpio-nomadik.c
>> +++ b/drivers/gpio/gpio-nomadik.c
>> @@ -28,7 +28,6 @@
>>
>>  #include <plat/pincfg.h>
>>  #include <plat/gpio-nomadik.h>
>> -#include <mach/hardware.h>
>>  #include <asm/gpio.h>
>
> While you're here, please replace this with linux/gpio.h - which will give
> us one less direct dependency on asm/ or mach/ includes from drivers.

OK I just deleted it, <linux/gpio.h> was included further up, so
this was just some dangling include anyway.

Yours,
Linus Walleij

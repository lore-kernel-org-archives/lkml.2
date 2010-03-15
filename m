Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965615Ab0COSIz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 14:08:55 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:54944 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933721Ab0COSIx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 14:08:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JhiAlZ95UCXTTOkT3rkjzhE/0IfvUDu8jEOyGW8sfBV9pPw4IxG9nzmTOLk54BIuT+
         K6x+TVCPBxQila4GCowTXdp1oIONfgdDnXUX9aSwinQxSLOuuwy9h9IKsV7SYEnnx4Tw
         RW77o6V+A6+KJNyMgpKN0DipyN3XDpjuENVk8=
MIME-Version: 1.0
In-Reply-To: <20100315053352.GC11552@elf.ucw.cz>
References: <1268622355-9966-1-git-send-email-chihau@gmail.com>
	 <20100315053352.GC11552@elf.ucw.cz>
Date: Mon, 15 Mar 2010 14:08:52 -0400
Message-ID: <f5ca57691003151108o5698e549g6c9a78495d6525f@mail.gmail.com>
Subject: Re: [PATCH] Staging: dream: generic_gpio: Use linux instead of asm 
	uaccess.h
From: Chihau Chau <chihau@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry I have been confused with the description of another patch.

I will fix the description.

Thanks Pavel!

2010/3/15 Pavel Machek <pavel@ucw.cz>:
> On Mon 2010-03-15 00:05:55, Chihau Chau wrote:
>> From: Chihau Chau <chihau@gmail.com>
>>
>> This is moving toward using <linux/uaccess.h> instead of the old
>> <asm/uaccess.h> file.
>
> Changelog does not match the patch.
>
> ...plus, was the patch actually tested?
>                                                                        Pavel
>
>> --- a/drivers/staging/dream/generic_gpio.c
>> +++ b/drivers/staging/dream/generic_gpio.c
>> @@ -18,7 +18,7 @@
>>  #include <linux/errno.h>
>>  #include <linux/slab.h>
>>  #include <linux/spinlock.h>
>> -#include <asm/gpio.h>
>> +#include <linux/gpio.h>
>>  #include "gpio_chip.h"
>>
>>  #define GPIO_NUM_TO_CHIP_INDEX(gpio) ((gpio)>>5)
>
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
>



-- 
Chihau Chau

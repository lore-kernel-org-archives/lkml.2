Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751359Ab1DVFAT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 01:00:19 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50230 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870Ab1DVFAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 01:00:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=vpCGdBZxalJRVj66yAQCzsaWP7m+Y+ANEB30h92XK+0eBYlsAi2KBGe01EbLv/ABBy
         6OyIbkca6Ki7e05zauGLw35QElOibPBkfaaXYHR0w7kvYifdDqNnW6yTNsJCuIZOrjX0
         wiCm/V1RWSkk+M2bjfEFzK9Giv3/6Mac3Jscc=
Message-ID: <4DB10B5D.1020602@gmail.com>
Date: Fri, 22 Apr 2011 09:00:13 +0400
From: Igor Plyatov <plyatov@gmail.com>
Reply-To: plyatov@gmail.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>
CC: Andrew Victor <linux@maxim.org.za>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mach-at91: gsia18s board improvements and bug fixes
References: <1303291399-4075-1-git-send-email-plyatov@gmail.com> <4DB04588.9000201@atmel.com>
In-Reply-To: <4DB04588.9000201@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nicolas!
> Hi Igor,
>
> Le 20/04/2011 11:23, Igor Plyatov :
>> * AT91_PIN_Pxxx port names replaced by human readable GPO_xxxx, GPI_xxxx,
>>    GPIO_xxxx names. This simplify source code and schematic maintenance.
> Maybe it simplifies schematic reading because the actual cpu pin names
> are not indicated on your schematic... But for code, the AT91 pin names
> are required, so, no for this part of the patch.
> You may know that there is an effort ongoing to minimize the amount of
> not needed / duplicated information in the kernel, I am afraid but I
> think this renaming is not needed.
>
> Moreover, I think that the "Buttons" part of the file:
> arch/arm/mach-at91/include/mach/gsia18s.h
> should be removed.

OK. Corrected.

>> * Active logic levels and default states corrected for GPOs.
> Ok for this.
>
>> * Replace small functions which use platform_register_device() by its direct
>>    calls.
> Ok for this.
>
>> * Remove GPIO_CARD_UNMOUNT_1 gpio_keys_button, because it not used.
> Ok for this.
>
>> * debounce_interval added for critical buttons.
> Ok for this.
>
>> * Remove unneeded GPI setup code for buttons, because this done by corresponding
>>    driver.
> I do not see this, can you elaborate?

The "gsia18s_add_device_buttons" function removed, because GPIs 
initialization done by "gpio_keys" driver and this function replaced by 
"platform_register_device" direct call.

>> * pcf8574x_0x20_setup() and pcf8574x_0x20_teardown functions small refactoring.
> Ok for this.
>
>> Signed-off-by: Igor Plyatov<plyatov@gmail.com>
> So, can you please rewrite your patch, we will be pleased to integrate
> it in a "fix" update of at91 Linux.
>
> Thanks, best regards,

Rewritten and will be published as "[PATCH v2] mach-at91: gsia18s board 
improvements and bug fixes".

Best regards!

-- 
Igor Plyatov


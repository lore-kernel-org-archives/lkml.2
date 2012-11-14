Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946019Ab2KNXez (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 18:34:55 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:39221 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945916Ab2KNXex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 18:34:53 -0500
Message-ID: <50A42A91.2000202@ahsoftware.de>
Date: Thu, 15 Nov 2012 00:34:41 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: "till@harbaum.org" <till@harbaum.org>
CC: Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH 1/2] i2c: Add possibility for user-defined (i2c-)devices
 for bus-drivers.
References: <1352829968-4908-1-git-send-email-holler@ahsoftware.de>  <20121113195533.6db71716@endymion.delvare> <50A2AC28.7050304@ahsoftware.de>  <20121113220835.111a178a@endymion.delvare> <50A2BAA2.6090009@ahsoftware.de>  <20121113224246.768bf734@endymion.delvare> <50A2DA0C.3090507@ahsoftware.de>  <20121114104050.79df8cd9@endymion.delvare>   <50A390CC.9000208@ahsoftware.de> <1352920954.19432.2.camel@Nokia-N900>
In-Reply-To: <1352920954.19432.2.camel@Nokia-N900>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 14.11.2012 20:22, schrieb till@harbaum.org:
> Hi,
>
> i have seen i2c chips going nuts because some probing actually affected the chips state. So i fully agree with Jean here.

I'm fully aware of that.

> I2C just isn't meant to be used for hot plugging. And so isn't the i2c-tiny-usb. It's more a hacking and testing device and is e.g. very convenient to test i2c client drivers or to test some new i2c hardware. But i have never had a need for this before user land was available. And once it is you can really do any magic you want using e.g. udev and sysfs.

So I conclude you don't accept my patch too.

> Also if you really need some chip to be available at boot time, then usb isn't for you. Usb can take pretty long to enumerate etc and you can never be sure when exactly a device shows up on the usb bus. You'd thus additionally need some means of blocking the entire boot process if you want to enforce that. E.g. the kernel can wait for boot disks to appear for exactly this reason. But it wouldn't make much sense to delay the boot for less cruicial things. Boot time is a critical thing and only the most important things are supposed to have a negative impact on that.

Some people are booting from USB, including the small server this mail 
goes through. I wonder why you consider the boot time a critical thing. 
This device isn't meant for some industrial (embedded) application. And 
most people are booting only seldom their desktop (not to speak about 
servers).


> If you wan't an i2c device to be available at boot time, then you might consider to connect it to some non-volatile i2c bus. I am pretty sure the raspberry pi has one.

I don't have a Rasberry Pi and I don't need one.

Sorry, but think all of you have the impression I'm a dumb kid, playing 
with some silly hardware. How does that come? I might be even older than 
you. ;)

Anyway, if someone of you is curious why I've undergone all the pain 
trying to submit a simple patch, here you can find a first draft:

http://ahsoftware.de/usb-rtc/

Regards,

Alexander

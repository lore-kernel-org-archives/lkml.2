Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141Ab1AaTg3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 14:36:29 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44566 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179Ab1AaTg2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 14:36:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=gyWIxfkvOtb9kz0nlrLWiGNcWxnXQRrqm14JalvyzE3/Z9Ty2xgtPKkuFiBNOww+/s
         7IzgliVxE2gNQksNYXN24Hw2oQHV6i46KUMUt6qGcyKuQ01MqyvfFBG0wb+qE/7LcWZR
         ABw59FCmkZslmT6viAmMHds9xzov76QF+/SEw=
MIME-Version: 1.0
In-Reply-To: <20110131192242.GB23722@sirena.org.uk>
References: <20110131135147.GB3883@oksana.dev.rtsoft.ru> <20110131154354.GC3819@enneenne.com>
 <20110131160321.GA23546@oksana.dev.rtsoft.ru> <AANLkTikr3LL-+4LObBaCTo7JGTFTRdVbpbbUH4nfJ28X@mail.gmail.com>
 <4D470B42.7050301@metafoo.de> <20110131192242.GB23722@sirena.org.uk>
From: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>
Date: Mon, 31 Jan 2011 20:35:47 +0100
Message-ID: <AANLkTi=zc_Ft6K=QP70-fUASO+0pO_2O8Cp6W6LL08MS@mail.gmail.com>
Subject: Re: Fwd: [PATCH] bq27x00_battery: Add new properties
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Grazvydas Ignotas <notasas@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/1/31 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> On Mon, Jan 31, 2011 at 08:19:30PM +0100, Lars-Peter Clausen wrote:
>> On 01/31/2011 07:07 PM, Pali Roh??r wrote:
>> > 2011/1/31 Anton Vorontsov <cbouatmailru@gmail.com>:
>> >> On Mon, Jan 31, 2011 at 04:43:56PM +0100, Rodolfo Giometti wrote:
>
>> >>>> +MODULE_ALIAS("i2c:bq27000");
>> >>>> +MODULE_ALIAS("i2c:bq27200");
>> >>>> +MODULE_ALIAS("i2c:bq27500");
>
>> >> Btw, this is actually another bugfix. Pali, you might want to separate
>> >> it into yet another patch.
>
>> > Ok, I separate aliases to new patch.
>
>> The bq27000 is not an I2C device.
>
> Also, even if it were an I2C device this isn't how I2C devices get their
> module loading information set up - they use MODULE_DEVICE_TABLE().
>

If bq27000 is not I2C device it will remove line. My patch was primary
for Nokia N900 - RX51 board and it has battery bq27200 which is i2c
device. For autoloading this module I used MODULE_ALIAS("i2c:bq27200")
which works fine. Aliases was used in other i2c modules for Nokia N900
too.

Can you give me example how to use MODULE_DEVICE_TABLE (if alias is
not good solution)?

-- 
Pali Rohár
pali.rohar@gmail.com

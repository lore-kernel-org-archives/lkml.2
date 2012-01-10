Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684Ab2AJHlE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 02:41:04 -0500
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:32990 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750989Ab2AJHlB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 02:41:01 -0500
MIME-Version: 1.0
In-Reply-To: <CAH9JG2U7RbnKQRwrOyNQj7Ooa5aOxi3-jShzw7pbRprx-=w55w@mail.gmail.com>
References: <1326159027-21185-1-git-send-email-ameya.palande@ti.com>
	<20120110020205.GA11831@kroah.com>
	<CAH9JG2U7RbnKQRwrOyNQj7Ooa5aOxi3-jShzw7pbRprx-=w55w@mail.gmail.com>
Date: Mon, 9 Jan 2012 23:40:59 -0800
Message-ID: <CAHFNHeUBBcfV89A-G=hqToHBf9v3X8+V5N22QNuE7TECS=z21A@mail.gmail.com>
Subject: Re: [PATCH] Texas Instruments DRV2665 Piezo Haptics Driver
From: "Palande, Ameya" <ameya.palande@ti.com>
To: Kyungmin Park <kmpark@infradead.org>
Cc: Greg KH <greg@kroah.com>, arnd@arndb.de, linux-kernel@vger.kernel.org,
        linux-input <linux-input@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 9, 2012 at 6:35 PM, Kyungmin Park <kmpark@infradead.org> wrote:
> On 1/10/12, Greg KH <greg@kroah.com> wrote:
>> On Mon, Jan 09, 2012 at 05:30:27PM -0800, Ameya Palande wrote:
>>> Texas Instruments's DRV2665 is a piezo haptic driver which is capable of
>>> driving both high-voltage and low-voltage piezo haptic actuators.
>>>
>>> Signed-off-by: Ameya Palande <ameya.palande@ti.com>
>>> ---
>>>  MAINTAINERS               |    5 +
>>>  drivers/misc/Kconfig      |    7 +
>>>  drivers/misc/Makefile     |    1 +
>>>  drivers/misc/ti_drv2665.c |  448
>>> +++++++++++++++++++++++++++++++++++++++++++++
>>
>> Where is the Documentation/ABI/ entries for this driver?
>>
>> And most importantly, why do you feel this is a "misc" driver and not an
>> iio driver instead?
> Hi,
>
> In case of haptic, now it's handled at input driver using ff-memless
> Please see the drivers/input/misc/Kconfig. you can see the already
> merged haptic/vibrator codes.
>
> Thank you,
> Kyungmin Park

Hi Kyungmin,

DRV2665 IC drives piezo actuator which enables a wide variety of
high-resolution haptic effects, including feedback localized to
specific areas of the device, as well as vibrations and pulses that
change in frequency based on how the user is interacting with the
device. However it is not a vibra chip so I didn't put it under
input/misc/

It comes under the category of ICs like DRV8662:
http://www.ti.com/lit/ds/symlink/drv8662.pdf

Cheers,
Ameya.

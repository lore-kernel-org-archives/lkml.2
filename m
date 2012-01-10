Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025Ab2AJCfT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 21:35:19 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:49782 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755960Ab2AJCfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 21:35:17 -0500
MIME-Version: 1.0
In-Reply-To: <20120110020205.GA11831@kroah.com>
References: <1326159027-21185-1-git-send-email-ameya.palande@ti.com>
	<20120110020205.GA11831@kroah.com>
Date: Tue, 10 Jan 2012 11:35:16 +0900
X-Google-Sender-Auth: zxWPJYH9JjUDMOl88yGQ5ghIwhI
Message-ID: <CAH9JG2U7RbnKQRwrOyNQj7Ooa5aOxi3-jShzw7pbRprx-=w55w@mail.gmail.com>
Subject: Re: [PATCH] Texas Instruments DRV2665 Piezo Haptics Driver
From: Kyungmin Park <kmpark@infradead.org>
To: Greg KH <greg@kroah.com>
Cc: Ameya Palande <ameya.palande@ti.com>, arnd@arndb.de,
        linux-kernel@vger.kernel.org,
        linux-input <linux-input@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/10/12, Greg KH <greg@kroah.com> wrote:
> On Mon, Jan 09, 2012 at 05:30:27PM -0800, Ameya Palande wrote:
>> Texas Instruments's DRV2665 is a piezo haptic driver which is capable of
>> driving both high-voltage and low-voltage piezo haptic actuators.
>>
>> Signed-off-by: Ameya Palande <ameya.palande@ti.com>
>> ---
>>  MAINTAINERS               |    5 +
>>  drivers/misc/Kconfig      |    7 +
>>  drivers/misc/Makefile     |    1 +
>>  drivers/misc/ti_drv2665.c |  448
>> +++++++++++++++++++++++++++++++++++++++++++++
>
> Where is the Documentation/ABI/ entries for this driver?
>
> And most importantly, why do you feel this is a "misc" driver and not an
> iio driver instead?
Hi,

In case of haptic, now it's handled at input driver using ff-memless
Please see the drivers/input/misc/Kconfig. you can see the already
merged haptic/vibrator codes.

Thank you,
Kyungmin Park
>
> thanks,
>
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

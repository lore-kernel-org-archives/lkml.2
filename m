Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927Ab2AJHtT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 02:49:19 -0500
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:47352 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751247Ab2AJHtS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 02:49:18 -0500
MIME-Version: 1.0
In-Reply-To: <20120110020205.GA11831@kroah.com>
References: <1326159027-21185-1-git-send-email-ameya.palande@ti.com>
	<20120110020205.GA11831@kroah.com>
Date: Mon, 9 Jan 2012 23:49:17 -0800
Message-ID: <CAHFNHeWDQFyusaXjb1h=Ren9yhCjvLRAdyM1oc8_AFb4+fRY-w@mail.gmail.com>
Subject: Re: [PATCH] Texas Instruments DRV2665 Piezo Haptics Driver
From: "Palande, Ameya" <ameya.palande@ti.com>
To: Greg KH <greg@kroah.com>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 9, 2012 at 6:02 PM, Greg KH <greg@kroah.com> wrote:
> On Mon, Jan 09, 2012 at 05:30:27PM -0800, Ameya Palande wrote:
>> Texas Instruments's DRV2665 is a piezo haptic driver which is capable of
>> driving both high-voltage and low-voltage piezo haptic actuators.
>>
>> Signed-off-by: Ameya Palande <ameya.palande@ti.com>
>> ---
>>  MAINTAINERS               |    5 +
>>  drivers/misc/Kconfig      |    7 +
>>  drivers/misc/Makefile     |    1 +
>>  drivers/misc/ti_drv2665.c |  448 +++++++++++++++++++++++++++++++++++++++++++++
>
> Where is the Documentation/ABI/ entries for this driver?
>
> And most importantly, why do you feel this is a "misc" driver and not an
> iio driver instead?
>
> thanks,
>
> greg k-h

Hi Gerg,

I guess iio will be the better place for this driver.
Thanks for suggesting it :)
I will send another patch which will use iio infrastructure.

Cheers,
Ameya.

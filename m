Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281Ab2LJV06 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 16:26:58 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:58866 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab2LJV05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 16:26:57 -0500
Message-ID: <50C65381.8010609@ahsoftware.de>
Date: Mon, 10 Dec 2012 22:26:25 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20121002 Thunderbird/15.0.1
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        Jonathan Cameron <jic23@cam.ac.uk>, rtc-linux@googlegroups.com,
        Alessandro Zummo <a.zummo@towertech.it>,
        srinivas pandruvada <srinivas.pandruvada@intel.com>
Subject: Re: [PATCH 3/3 v2] iio: add rtc-driver for HID sensors of type time
References: <50C5DFCC.60203@ahsoftware.de> <1355151119-2489-1-git-send-email-holler@ahsoftware.de> <50C61675.2000407@metafoo.de> <50C63BBD.3080202@ahsoftware.de> <50C64484.4060306@metafoo.de>
In-Reply-To: <50C64484.4060306@metafoo.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 10.12.2012 21:22, schrieb Lars-Peter Clausen:
> On 12/10/2012 08:45 PM, Alexander Holler wrote:
>> Am 10.12.2012 18:05, schrieb Lars-Peter Clausen:
>>
>>> Looks pretty good now. But there are still some IIO remnants which should be
>>> removed as well. Also the driver should move to drivers/rtc/ since, well,
>>> it's a rtc driver not a IIO driver.
>>
>> I think it still should be stick to iio, because that is where all HID
>> sensors currently are found and where the user would expect to find such
>> a driver.
> 
> That's because all the current IIO sensor drivers fall in the IIO domain. This
> one clearly is a RTC driver, so it belongs in drivers/rtc/

Where nobody will find it if he searches for drivers for his HID sensor.
I still see it as HID sensor driver and not a rtc-driver.
But ...

> 
>>
>>>> +/* Channel definitions */
>>>> +static const struct iio_chan_spec hid_time_channels[TIME_RTC_CHANNEL_MAX] = {
>>
>> And that is imho the last remaining iio-stuff. If necessary I can remove
>> it too.
> 
> That and the remaining bits of the read_raw callback.

Ok. I will make a v3.

Alexander

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953Ab2LJUVv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 15:21:51 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:55516 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751249Ab2LJUVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 15:21:50 -0500
Message-ID: <50C64484.4060306@metafoo.de>
Date: Mon, 10 Dec 2012 21:22:28 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121027 Icedove/3.0.11
MIME-Version: 1.0
To: Alexander Holler <holler@ahsoftware.de>
CC: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        Jonathan Cameron <jic23@cam.ac.uk>, rtc-linux@googlegroups.com,
        Alessandro Zummo <a.zummo@towertech.it>,
        srinivas pandruvada <srinivas.pandruvada@intel.com>
Subject: Re: [PATCH 3/3 v2] iio: add rtc-driver for HID sensors of type time
References: <50C5DFCC.60203@ahsoftware.de> <1355151119-2489-1-git-send-email-holler@ahsoftware.de> <50C61675.2000407@metafoo.de> <50C63BBD.3080202@ahsoftware.de>
In-Reply-To: <50C63BBD.3080202@ahsoftware.de>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2012 08:45 PM, Alexander Holler wrote:
> Am 10.12.2012 18:05, schrieb Lars-Peter Clausen:
> 
>> Looks pretty good now. But there are still some IIO remnants which should be
>> removed as well. Also the driver should move to drivers/rtc/ since, well,
>> it's a rtc driver not a IIO driver.
> 
> I think it still should be stick to iio, because that is where all HID
> sensors currently are found and where the user would expect to find such
> a driver.

That's because all the current IIO sensor drivers fall in the IIO domain. This
one clearly is a RTC driver, so it belongs in drivers/rtc/

> 
>>> +/* Channel definitions */
>>> +static const struct iio_chan_spec hid_time_channels[TIME_RTC_CHANNEL_MAX] = {
> 
> And that is imho the last remaining iio-stuff. If necessary I can remove
> it too.

That and the remaining bits of the read_raw callback.

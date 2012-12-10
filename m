Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751555Ab2LJNNh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 08:13:37 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:43594 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284Ab2LJNNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 08:13:35 -0500
Message-ID: <50C5DFCC.60203@ahsoftware.de>
Date: Mon, 10 Dec 2012 14:12:44 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        Jonathan Cameron <jic23@cam.ac.uk>, rtc-linux@googlegroups.com,
        Alessandro Zummo <a.zummo@towertech.it>,
        srinivas pandruvada <srinivas.pandruvada@intel.com>
Subject: Re: [PATCH 3/3] iio: add rtc-driver for HID sensors of type time
References: <1355055699-2965-1-git-send-email-holler@ahsoftware.de> <1355055699-2965-4-git-send-email-holler@ahsoftware.de> <50C48A42.9070806@metafoo.de> <50C4BEFF.2010304@ahsoftware.de> <50C4D58E.4020702@ahsoftware.de> <50C4E464.9070509@metafoo.de>
In-Reply-To: <50C4E464.9070509@metafoo.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 09.12.2012 20:20, schrieb Lars-Peter Clausen:

> I agree with what you wrote above. It just doesn't make sense to register a IIO
> device for a RTC type device. Just rip out all the IIO related bits from the
> driver and it will be fine.

Ah, I misunderstood you. Yes, you are right. As I already have removed 
the buffer, trigger and the exposure of attributes in sysfs (the driver 
started as a copy from one of the other hid sensor drivers), the IIO 
device itself doesn't make sense anymore.

I will remove it.

Regards,

Alexander


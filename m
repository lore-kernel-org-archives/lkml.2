Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241Ab2LKNyI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 08:54:08 -0500
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:45654 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163Ab2LKNyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 08:54:06 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <50C73AFC.1050904@jic23.retrosnub.co.uk>
Date: Tue, 11 Dec 2012 13:54:04 +0000
From: Jonathan Cameron <jic23@jic23.retrosnub.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Alexander Holler <holler@ahsoftware.de>
CC: Lars-Peter Clausen <lars@metafoo.de>, Jonathan Cameron <jic23@kernel.org>,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        Jonathan Cameron <jic23@cam.ac.uk>, rtc-linux@googlegroups.com,
        Alessandro Zummo <a.zummo@towertech.it>,
        srinivas pandruvada <srinivas.pandruvada@intel.com>
Subject: Re: [PATCH 3/3 v2] iio: add rtc-driver for HID sensors of type time
References: <50C5DFCC.60203@ahsoftware.de> <1355151119-2489-1-git-send-email-holler@ahsoftware.de> <50C61675.2000407@metafoo.de> <50C63BBD.3080202@ahsoftware.de> <50C64484.4060306@metafoo.de> <50C65381.8010609@ahsoftware.de> <50C6567D.7080303@metafoo.de> <50C65746.8030609@kernel.org> <50C6674D.1000901@ahsoftware.de> <50C6FD60.7080300@jic23.retrosnub.co.uk> <50C6FF71.1010504@metafoo.de> <50C72967.5050807@ahsoftware.de>
In-Reply-To: <50C72967.5050807@ahsoftware.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/12 12:39, Alexander Holler wrote:
> Am 11.12.2012 10:40, schrieb Lars-Peter Clausen:
>
>>> Yes, move the header or merge into existing one as makes sense.
>>> I'm not pulling this driver into the IIO tree (unless for some
>>> reason Alessandro wants me to and I can't think why he would...).
>>>
>>
>> Alessandro has been pretty quiet for quite some time now. Luckily Andrew
>> Morton usually picks up the stuff for orphaned subsystems. So put him
>> on Cc
>> for v4.
>
> Will do it. Thanks a lot for your review.
>
> I willl post the whole series (4 patches including the merge of
> hid-sensor-attributes.h) again, when I've finished v3 of the driver
> (hopefully this evening), marking some patches as RESEND. So 3 out of
> those 4 patches will be for iio (as hid-sensor-hub is part of it), and
> the last one, the rtc driver itself, will be for the rtc subsystem. I
> don't know if they have to be pulled by different maintainers. ;)
>
> Regards,
>
> Alexander
We'll see what Andrew says.  We can take the lot through IIO
(doubt Greg will mind) as long as we have the correct acks to do so
(or at least statements of not caring ;)


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751749Ab2LQHkH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 02:40:07 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:49682 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326Ab2LQHkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 02:40:05 -0500
Message-ID: <50CECBFC.2030807@ahsoftware.de>
Date: Mon, 17 Dec 2012 08:38:36 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Alessandro Zummo <a.zummo@towertech.it>
CC: Lars-Peter Clausen <lars@metafoo.de>,
        Jonathan Cameron <jic23@jic23.retrosnub.co.uk>,
        Jonathan Cameron <jic23@kernel.org>, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, Jonathan Cameron <jic23@cam.ac.uk>,
        rtc-linux@googlegroups.com,
        srinivas pandruvada <srinivas.pandruvada@intel.com>
Subject: Re: [PATCH 3/3 v2] iio: add rtc-driver for HID sensors of type time
References: <50C5DFCC.60203@ahsoftware.de> <1355151119-2489-1-git-send-email-holler@ahsoftware.de> <50C61675.2000407@metafoo.de> <50C63BBD.3080202@ahsoftware.de> <50C64484.4060306@metafoo.de> <50C65381.8010609@ahsoftware.de> <50C6567D.7080303@metafoo.de> <50C65746.8030609@kernel.org> <50C6674D.1000901@ahsoftware.de> <50C6FD60.7080300@jic23.retrosnub.co.uk> <50C6FF71.1010504@metafoo.de> <20121216231552.4ced4d25@linux.lan.towertech.it>
In-Reply-To: <20121216231552.4ced4d25@linux.lan.towertech.it>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 16.12.2012 23:15, schrieb Alessandro Zummo:
> On Tue, 11 Dec 2012 10:40:01 +0100
> Lars-Peter Clausen <lars@metafoo.de> wrote:
>
>>> Yes, move the header or merge into existing one as makes sense.
>>> I'm not pulling this driver into the IIO tree (unless for some
>>> reason Alessandro wants me to and I can't think why he would...).
>>>
>>
>> Alessandro has been pretty quiet for quite some time now. Luckily Andrew
>> Morton usually picks up the stuff for orphaned subsystems. So put him on Cc
>> for v4.
>
>   Still reading e-mails ;) Andrew monitors the rtc mailing list and picks up
>   the patches that do not need to go in any arch's main tree, which is the suggested
>   way as, with modern chipsets, the RTCs shares hw with many other drivers.

Reading just the latest patch (v5) might be faster. ;)

It basically doesn't do much. On call of read_time() a so called report 
with the time values (year, month, ...) is requested from the device, 
rtc_time is filled with them, done.

Regards,

Alexander

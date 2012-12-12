Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010Ab2LLKPL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 05:15:11 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:53687 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab2LLKPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 05:15:09 -0500
Message-ID: <50C8591A.3030301@ahsoftware.de>
Date: Wed, 12 Dec 2012 11:14:50 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        Jonathan Cameron <jic23@cam.ac.uk>, rtc-linux@googlegroups.com,
        Alessandro Zummo <a.zummo@towertech.it>,
        srinivas pandruvada <srinivas.pandruvada@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/4 v3] rtc: add rtc-driver for HID sensors of type time
References: <50C73AFC.1050904@jic23.retrosnub.co.uk> <1355250106-3114-1-git-send-email-holler@ahsoftware.de> <1355250106-3114-4-git-send-email-holler@ahsoftware.de> <50C8539C.1070509@metafoo.de>
In-Reply-To: <50C8539C.1070509@metafoo.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 12.12.2012 10:51, schrieb Lars-Peter Clausen:

> Looks good, but as I wrote during the last review the __devinits need to go.
> A few other suggerstions online

Oh, have forgotten it. Ok, will make a v4, changing the other few things 
too.

>> +	case HID_USAGE_SENSOR_TIME_MONTH:
>> +		time_buf->tm_mon = --*(u8 *)raw_data;

Time sensors are sending the month in the range 1-12, not 0-11.

Regards,

Alexander


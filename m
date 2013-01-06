Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774Ab3AFLvX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 06:51:23 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:56004 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926Ab3AFLvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 06:51:21 -0500
Message-ID: <50E96538.4010302@kernel.org>
Date: Sun, 06 Jan 2013 11:51:20 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Alexander Holler <holler@ahsoftware.de>, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, Jonathan Cameron <jic23@cam.ac.uk>,
        Lars-Peter Clausen <lars@metafoo.de>, rtc-linux@googlegroups.com,
        Alessandro Zummo <a.zummo@towertech.it>,
        srinivas pandruvada <srinivas.pandruvada@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/4 RESEND] iio: Add Usage IDs for HID time sensors.
References: <50CC6FE3.6060705@ahsoftware.de> <1355575537-10093-1-git-send-email-holler@ahsoftware.de> <alpine.LNX.2.00.1301031040260.27348@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1301031040260.27348@pobox.suse.cz>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/2013 09:40 AM, Jiri Kosina wrote:
> On Sat, 15 Dec 2012, Alexander Holler wrote:
> 
>> These are Usage IDs for the attributes year, month, day,
>> hour, minute and second, needed to read HID time sensors.
>>
>> Signed-off-by: Alexander Holler <holler@ahsoftware.de>
> 
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Added to togreg branch of git://git.kernel.org/pub/scm/linux/kernel/git/jic23/iio.git

Thanks,

> 
>> ---
>>  include/linux/hid-sensor-ids.h |    9 +++++++++
>>  1 files changed, 9 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/linux/hid-sensor-ids.h b/include/linux/hid-sensor-ids.h
>> index ca8d7e9..3754ea9 100644
>> --- a/include/linux/hid-sensor-ids.h
>> +++ b/include/linux/hid-sensor-ids.h
>> @@ -67,6 +67,15 @@
>>  #define HID_USAGE_SENSOR_ORIENT_MAGN_FLUX_Y_AXIS		0x200486
>>  #define HID_USAGE_SENSOR_ORIENT_MAGN_FLUX_Z_AXIS		0x200487
>>  
>> +/* Time (2000a0) */
>> +#define HID_USAGE_SENSOR_TIME					0x2000a0
>> +#define HID_USAGE_SENSOR_TIME_YEAR				0x200521
>> +#define HID_USAGE_SENSOR_TIME_MONTH				0x200522
>> +#define HID_USAGE_SENSOR_TIME_DAY				0x200523
>> +#define HID_USAGE_SENSOR_TIME_HOUR				0x200525
>> +#define HID_USAGE_SENSOR_TIME_MINUTE				0x200526
>> +#define HID_USAGE_SENSOR_TIME_SECOND				0x200527
>> +
>>  /* Units */
>>  #define HID_USAGE_SENSOR_UNITS_NOT_SPECIFIED			0x00
>>  #define HID_USAGE_SENSOR_UNITS_LUX				0x01
>> -- 
>> 1.7.8.6
>>
> 

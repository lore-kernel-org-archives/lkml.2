Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441Ab1KQFVE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 00:21:04 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:8275 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049Ab1KQFVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 00:21:01 -0500
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee61b-b7b7fae000005864-8d-4ec499bb164e
Message-id: <4EC4999F.8030604@samsung.com>
Date: Thu, 17 Nov 2011 14:20:31 +0900
From: Donggeun Kim <dg77.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.15) Gecko/20110419
 Thunderbird/3.1.9
To: guenter.roeck@ericsson.com
Cc: Paul Bolle <pebolle@tiscali.nl>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
        "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7] hwmon: Add driver for EXYNOS4 TMU
References: <1315388948-20346-1-git-send-email-dg77.kim@samsung.com>
 <1321389279.20271.241.camel@x61.thuisdomein>
 <1321392253.2309.379.camel@groeck-laptop>
In-reply-to: <1321392253.2309.379.camel@groeck-laptop>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011년 11월 16일 06:24, Guenter Roeck wrote:
> On Tue, 2011-11-15 at 15:34 -0500, Paul Bolle wrote:
>> (This is an attempt to do a bit of review after the fact. See, this
>> appears to be to the patch that ended up as commit
>> 9d97e5c81e15afaef65d00f077f863c94f750839 in the mainline tree. Since
>> that tree is at v3.2-rc2 now this might be in time for v3.2. If my
>> comments have merit, that is.)
>>
>> On Wed, 2011-09-07 at 18:49 +0900, Donggeun Kim wrote:
>>> This patch allows to read temperature
>>> from TMU(Thermal Management Unit) of SAMSUNG EXYNOS4 series of SoC.
>> [...]
>>> diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
>>> index 0b62c3c..c6fb761 100644
>>> --- a/drivers/hwmon/Kconfig
>>> +++ b/drivers/hwmon/Kconfig
>>> @@ -303,6 +303,16 @@ config SENSORS_DS1621
>>>  	  This driver can also be built as a module.  If so, the module
>>>  	  will be called ds1621.
>>>  
>>> +config SENSORS_EXYNOS4_TMU
>>> +	tristate "Temperature sensor on Samsung EXYNOS4"
>>> +	depends on EXYNOS4_DEV_TMU
>>
>> It doesn't look like that Kconfig symbol is part of the tree just yet.
>> That means people will not be able to build this driver from the
>> mainline tree. Why is this dependency needed? In a (rather quick) scan
>> of the code of this driver I couldn't spot anything not yet available in
>> the tree.
>>
> I have to defer to the driver author for that. Maybe the dependency was
> renamed at some point, or removed altogether.
> 
The dependency will be renamed to 'ARCH_EXYNOS4'.

Thanks,
Donggeun


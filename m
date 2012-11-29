Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751350Ab2K2Fxi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 00:53:38 -0500
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:60371 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751009Ab2K2Fxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 00:53:36 -0500
Message-ID: <50B6F8AC.6050307@marvell.com>
Date: Thu, 29 Nov 2012 13:54:52 +0800
From: Qing Xu <qingx@marvell.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Chao Xie <cxie4@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH 0/7] mfd: update on max8925 for DT support
References: <1352187305-9660-1-git-send-email-qingx@marvell.com> <CAN1soZzAZ9Od_5jC0ZFdw03c5P9Q+gJQswTwp0M1YWM_ti+9xw@mail.gmail.com>
In-Reply-To: <CAN1soZzAZ9Od_5jC0ZFdw03c5P9Q+gJQswTwp0M1YWM_ti+9xw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Nov 2012 05:53:16.0359 (UTC) FILETIME=[D38DF570:01CDCDF5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23/2012 05:09 PM, Haojian Zhuang wrote:
> On Tue, Nov 6, 2012 at 3:35 PM, Qing Xu <qingx@marvell.com> wrote:
>> From: Qing Xu <qingx@marvell.com>
>>
>> 1. add irqdomain for max8925, it is necessary for dt support
>> 2. bug fix in max8925 mfd devices'irq base and device registry failure
>> 3. support DT for max8925 mfd devices
>>
>> Qing Xu (7):
>>    mfd: max8925: add irqdomain for dt
>>    mfd: max8925: fix mfd device register failure
>>    mfd: max8925: fix onkey driver irq base
>>    mfd: max8925: support dt for power supply
>>    mfd: max8925: support dt for regulator
>>    mfd: max8925: support dt for backlight
>>    mfd: max8925: add dts
>>
>>   arch/arm/boot/dts/mmp2-brownstone.dts |  166 +++++++++++++++++++++++++++++++++
>>   arch/arm/boot/dts/mmp2.dtsi           |    4 +-
>>   drivers/input/misc/max8925_onkey.c    |    3 -
>>   drivers/mfd/max8925-core.c            |  107 +++++++++++++--------
>>   drivers/mfd/max8925-i2c.c             |   32 ++++++-
>>   drivers/power/max8925_power.c         |   57 ++++++++++-
>>   drivers/regulator/max8925-regulator.c |   35 +++++++-
>>   drivers/video/backlight/max8925_bl.c  |   31 ++++++-
>>   include/linux/mfd/max8925.h           |   12 ++-
>>   9 files changed, 389 insertions(+), 58 deletions(-)
>>
> No document on devicetree binding?
I added a new patch of "Documentation: add docs for max8925 dt",
please help to review, thanks a lot!

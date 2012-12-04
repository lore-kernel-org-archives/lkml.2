Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284Ab2LDHLs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 02:11:48 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:54930 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216Ab2LDHLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 02:11:46 -0500
MIME-Version: 1.0
In-Reply-To: <50B6F8AC.6050307@marvell.com>
References: <1352187305-9660-1-git-send-email-qingx@marvell.com>
	<CAN1soZzAZ9Od_5jC0ZFdw03c5P9Q+gJQswTwp0M1YWM_ti+9xw@mail.gmail.com>
	<50B6F8AC.6050307@marvell.com>
Date: Tue, 4 Dec 2012 15:11:45 +0800
Message-ID: <CAN1soZzTYjU9nEe1hQWAwz2R0GRfvaQ7HyaMZ3uNxtBV0X14uA@mail.gmail.com>
Subject: Re: [PATCH 0/7] mfd: update on max8925 for DT support
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Qing Xu <qingx@marvell.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Chao Xie <cxie4@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 1:54 PM, Qing Xu <qingx@marvell.com> wrote:
> On 11/23/2012 05:09 PM, Haojian Zhuang wrote:
>>
>> On Tue, Nov 6, 2012 at 3:35 PM, Qing Xu <qingx@marvell.com> wrote:
>>>
>>> From: Qing Xu <qingx@marvell.com>
>>>
>>> 1. add irqdomain for max8925, it is necessary for dt support
>>> 2. bug fix in max8925 mfd devices'irq base and device registry failure
>>> 3. support DT for max8925 mfd devices
>>>
>>> Qing Xu (7):
>>>    mfd: max8925: add irqdomain for dt
>>>    mfd: max8925: fix mfd device register failure
>>>    mfd: max8925: fix onkey driver irq base
>>>    mfd: max8925: support dt for power supply
>>>    mfd: max8925: support dt for regulator
>>>    mfd: max8925: support dt for backlight
>>>    mfd: max8925: add dts
>>>
>>>   arch/arm/boot/dts/mmp2-brownstone.dts |  166
>>> +++++++++++++++++++++++++++++++++
>>>   arch/arm/boot/dts/mmp2.dtsi           |    4 +-
>>>   drivers/input/misc/max8925_onkey.c    |    3 -
>>>   drivers/mfd/max8925-core.c            |  107 +++++++++++++--------
>>>   drivers/mfd/max8925-i2c.c             |   32 ++++++-
>>>   drivers/power/max8925_power.c         |   57 ++++++++++-
>>>   drivers/regulator/max8925-regulator.c |   35 +++++++-
>>>   drivers/video/backlight/max8925_bl.c  |   31 ++++++-
>>>   include/linux/mfd/max8925.h           |   12 ++-
>>>   9 files changed, 389 insertions(+), 58 deletions(-)
>>>
>> No document on devicetree binding?
>
> I added a new patch of "Documentation: add docs for max8925 dt",
> please help to review, thanks a lot!

Acked.

Samuel,
How do you think about this patch series? From my view, it's ok.

Best Regards
Haojian

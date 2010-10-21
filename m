Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758397Ab0JUOxu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 10:53:50 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:33296 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758229Ab0JUOxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 10:53:48 -0400
Message-ID: <4CC053E3.4050207@metafoo.de>
Date: Thu, 21 Oct 2010 16:53:23 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: piotr@hosowicz.com
CC: rklein@nvidia.com, Anton Vorontsov <cbouatmailru@gmail.com>,
        broonie@opensource.wolfsonmicro.com, achew@nvidia.com, olof@lixom.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] POWER: Add gpio chager driver
References: <4CC02FF9.3050804@metafoo.de> <1287663957-30099-1-git-send-email-lars@metafoo.de> <4CC03563.3060908@example.com>
In-Reply-To: <4CC03563.3060908@example.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Piotr Hosowicz wrote:
> On 21.10.2010 14:25, Lars-Peter Clausen wrote:
>> This patch adds a simple driver for chargers indicating their online
>> status
>> through a GPIO pin.
>>
>> Signed-off-by: Lars-Peter Clausen<lars@metafoo.de>
>> ---
>>   drivers/power/Kconfig              |   10 ++
>>   drivers/power/Makefile             |    1 +
>>   drivers/power/gpio-charger.c       |  184
>> ++++++++++++++++++++++++++++++++++++
>>   include/linux/power/gpio-charger.h |   39 ++++++++
>>   4 files changed, 234 insertions(+), 0 deletions(-)
>>   create mode 100644 drivers/power/gpio-charger.c
>>   create mode 100644 include/linux/power/gpio-charger.h
>>
>> diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
>> index 0734356..90b1940 100644
>> --- a/drivers/power/Kconfig
>> +++ b/drivers/power/Kconfig
>> @@ -166,4 +166,14 @@ config BATTERY_INTEL_MID
>>         Say Y here to enable the battery driver on Intel MID
>>         platforms.
>>
>> +config CHARGER_GPIO
>> +    tristate "GPIO charger"
>> +    depends on GPIOLIB
>> +    help
>> +      Say Y to include support for chargers which report their online
>> status
>> +      through a GPIO pin.
>> +
>> +      This driver can be build as a module. If so, the module will be
>> +      called gpio-chager.
> 
> Shouldn't it say gpio-charger not gpio-chager? A typo.
> 
> Regards,
> 
> Piotr Hosowicz
> 

Hi

Yes, thanks.

- Lars

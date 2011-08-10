Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068Ab1HJFxh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 01:53:37 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60250 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347Ab1HJFxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 01:53:35 -0400
Message-ID: <4E421CD8.3090606@canonical.com>
Date: Wed, 10 Aug 2011 13:53:28 +0800
From: Ike Panhc <ike.pan@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110801 Thunderbird/6.0
MIME-Version: 1.0
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
CC: linux-kernel@vger.kernel.org, mjg@redhat.com,
        platform-driver-x86@vger.kernel.org
Subject: Re: [RESEND][PATCH 0/5] Support for the TS-5500 board
References: <1311887450-22235-1-git-send-email-vivien.didelot@savoirfairelinux.com> <20110809233208.1a71122e@lenov0n>
In-Reply-To: <20110809233208.1a71122e@lenov0n>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think platform-driver-x86 may not be the best mailing list for your patches.

Please try to use scripts/get_maintainer.pl and it can tell you who you shall ask for reviewing.

On 08/10/2011 11:32 AM, Vivien Didelot wrote:
> Le Thu, 28 Jul 2011 17:10:45 -0400,
> Vivien Didelot <vivien.didelot@savoirfairelinux.com> a écrit :
> 
>> This set of patches brings the support for the Technologic Systems
>> TS-5500 Single Board Computer.
>>
>> The first patch adds the base for the support of the board in
>> /arch/x86/platform/ts5500 and a documentation file in
>> Documentation/ABI/testing/sysfs-platform-ts5500.
>>
>> The second patch adds support for GPIO.
>>
>> The third patch adds support for the on-board LED.
>>
>> The fourth patch brings support for the Analogic/Digital converter.
>>
>> The fifth patch moves the already existing support for the Flash MTD
>> into the /arch/x86/platform/ts5500 directory.
>>
>> Jerome Oufella (1):
>>   gpio: add support for TS-5500 GPIO
>>
>> Jonas Fonseca (2):
>>   leds: add support for TS-5500 LED
>>   adc: add support for TS-5500 ADC
>>
>> Vivien Didelot (2):
>>   x86: base support for TS-5500 Single Board Computer
>>   mtd: move support for TS-5500 MTD
>>
>>  Documentation/ABI/testing/sysfs-platform-ts5500 |   46 +++
>>  MAINTAINERS                                     |   13 +
>>  arch/x86/Kconfig                                |    2 +
>>  arch/x86/platform/Makefile                      |    1 +
>>  arch/x86/platform/ts5500/Kconfig                |   47 +++
>>  arch/x86/platform/ts5500/Makefile               |    5 +
>>  arch/x86/platform/ts5500/ts5500.c               |  440
>> +++++++++++++++++++++++
>> arch/x86/platform/ts5500/ts5500_adc.c           |  326
>> +++++++++++++++++ arch/x86/platform/ts5500/ts5500_adc.h           |
>> 62 ++++ arch/x86/platform/ts5500/ts5500_flash.c         |  118 ++++++
>> arch/x86/platform/ts5500/ts5500_gpio.c          |  421
>> ++++++++++++++++++++++
>> arch/x86/platform/ts5500/ts5500_gpio.h          |   60 +++
>> arch/x86/platform/ts5500/ts5500_leds.c          |  133 +++++++
>> drivers/mtd/maps/Kconfig                        |   18 -
>> drivers/mtd/maps/Makefile                       |    1 -
>> drivers/mtd/maps/ts5500_flash.c                 |  121 ------- 16
>> files changed, 1674 insertions(+), 140 deletions(-) create mode
>> 100644 Documentation/ABI/testing/sysfs-platform-ts5500 create mode
>> 100644 arch/x86/platform/ts5500/Kconfig create mode 100644
>> arch/x86/platform/ts5500/Makefile create mode 100644
>> arch/x86/platform/ts5500/ts5500.c create mode 100644
>> arch/x86/platform/ts5500/ts5500_adc.c create mode 100644
>> arch/x86/platform/ts5500/ts5500_adc.h create mode 100644
>> arch/x86/platform/ts5500/ts5500_flash.c create mode 100644
>> arch/x86/platform/ts5500/ts5500_gpio.c create mode 100644
>> arch/x86/platform/ts5500/ts5500_gpio.h create mode 100644
>> arch/x86/platform/ts5500/ts5500_leds.c delete mode 100644
>> drivers/mtd/maps/ts5500_flash.c
>>
> 
> This set of patches has been sent two times without any answer yet.
> Can I have any feedback please?
> 
> Regards,
> Vivien.
> --
> To unsubscribe from this list: send the line "unsubscribe platform-driver-x86" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


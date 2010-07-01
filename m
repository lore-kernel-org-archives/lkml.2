Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116Ab0GAX5W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 19:57:22 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39453 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811Ab0GAX5U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 19:57:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=VhysQy8dYXanz0IQcsIBYoqkfVw666GCgeA/U1WIBAnrAK2wfyyHDuLZya5Qsn31DP
         LsbFb4UWmOrx1puExptTuXyTEpIfAzjU3uWNyd9L7H0IoeTFF8aoiqpgm1B3jcu/D/Iq
         Rtp2mt9BnIBqezNVYLHdaBAm2WMHuBf6qq+XY=
MIME-Version: 1.0
In-Reply-To: <AANLkTim9icxxarxlcC39tCnnAIwwBOF8l8a68nQy7xHQ@mail.gmail.com>
References: <cover.1277911345.git.siccegge@cs.fau.de>
	<e2a294ec1d41f1198f7ffae0e8bed2f67b41bbe8.1277911346.git.siccegge@cs.fau.de>
	<AANLkTim9icxxarxlcC39tCnnAIwwBOF8l8a68nQy7xHQ@mail.gmail.com>
Date: Fri, 2 Jul 2010 07:57:19 +0800
X-Google-Sender-Auth: rCeKNyqx-bZCM_IvBPtM3HGEG90
Message-ID: <AANLkTinaExfjcAFTSvvZV3Hi3nLAa8bDY6mkqBf9WgvM@mail.gmail.com>
Subject: Re: [PATCH 24/33] Removing dead ARCH_GUMSTIX_ORIG
From: Jaya Kumar <jayakumar.arm@gmail.com>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Christoph Egger <siccegge@cs.fau.de>,
       Russell King <linux@arm.linux.org.uk>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       vamos@i4.informatik.uni-erlangen.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 1, 2010 at 12:27 PM, Eric Miao <eric.y.miao@gmail.com> wrote:
> On Thu, Jul 1, 2010 at 12:01 AM, Christoph Egger <siccegge@cs.fau.de> wrote:
>> ARCH_GUMSTIX_ORIG doesn't exist in Kconfig, therefore removing all
>> references for it from the source code.
>>
>> Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
>
> Acked-by: Eric Miao <eric.y.miao@gmail.com>
>
> Cc'ed Jaya Kumar for additional thoughts.

Looks okay to me too. Thanks.

Acked-by: Jaya Kumar <jayakumar.lkml@gmail.com>

>
>> ---
>>  arch/arm/mach-pxa/include/mach/gumstix.h |   12 +-----------
>>  1 files changed, 1 insertions(+), 11 deletions(-)
>>
>> diff --git a/arch/arm/mach-pxa/include/mach/gumstix.h b/arch/arm/mach-pxa/include/mach/gumstix.h
>> index 06abd41..9b89868 100644
>> --- a/arch/arm/mach-pxa/include/mach/gumstix.h
>> +++ b/arch/arm/mach-pxa/include/mach/gumstix.h
>> @@ -14,25 +14,15 @@
>>
>>  /*
>>  GPIOn - Input from MAX823 (or equiv), normalizing USB +5V into a clean
>> -interrupt signal for determining cable presence. On the original gumstix,
>> -this is GPIO81, and GPIO83 needs to be defined as well. On the gumstix F,
>> +interrupt signal for determining cable presence. On the gumstix F,
>>  this moves to GPIO17 and GPIO37. */
>>
>>  /* GPIOx - Connects to USB D+ and used as a pull-up after GPIOn
>>  has detected a cable insertion; driven low otherwise. */
>>
>> -#ifdef CONFIG_ARCH_GUMSTIX_ORIG
>> -
>> -#define GPIO_GUMSTIX_USB_GPIOn         81
>> -#define GPIO_GUMSTIX_USB_GPIOx         83
>> -
>> -#else
>> -
>>  #define GPIO_GUMSTIX_USB_GPIOn         35
>>  #define GPIO_GUMSTIX_USB_GPIOx         41
>>
>> -#endif
>> -
>>  /* usb state change */
>>  #define GUMSTIX_USB_INTR_IRQ           IRQ_GPIO(GPIO_GUMSTIX_USB_GPIOn)
>>
>> --
>> 1.7.0.4
>>
>>
>

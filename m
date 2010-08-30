Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540Ab0H3Nfb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 09:35:31 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:55159 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752917Ab0H3Nfa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 09:35:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=kCbeOWmPq4ZbdGTkCFbt7ZJ46brx7CApzZbou+fkYufM+4ekcnbSav4HLB0uBsbLru
         2zx1Or3IbFlJvWtePELg9o8F8tmiV/oLY7HVUpiWrazCveRDsokzeiNwhoONjczXfARY
         J4IM0vNaHTjFwG9f0JvJmFIL8RysW0UfQ4+q8=
MIME-Version: 1.0
In-Reply-To: <006201cb483b$0e1727e0$2a4577a0$%kim@samsung.com>
References: <20100830114708.GA13140@july>
	<006201cb483b$0e1727e0$2a4577a0$%kim@samsung.com>
Date: Mon, 30 Aug 2010 22:35:29 +0900
X-Google-Sender-Auth: splVs_MYJFjljoYazKgv2TCVX9c
Message-ID: <AANLkTinYiG2y=x48kkV=XMzpsc_a677Xsox6dNkuHMF3@mail.gmail.com>
Subject: Re: [PATCH 1/3] ARM: Samsung S5P: Move the common Samsung S5P series
 GPIO level type
From: Kyungmin Park <kmpark@infradead.org>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        jy0922.shim@samsung.com, m.szyprowski@samsung.com, ben-linux@fluff.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 30, 2010 at 9:01 PM, Kukjin Kim <kgene.kim@samsung.com> wrote:
> Kyungmin Park wrote:
>>
>> From: Kyungmin Park <kyungmin.park@samsung.com>
>>
>> Samsung S5P series has common level type. It's different from S3C series.
>>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>  arch/arm/plat-samsung/include/plat/gpio-core.h |    6 ++++++
>>  1 files changed, 6 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/arm/plat-samsung/include/plat/gpio-core.h
> b/arch/arm/plat-
>> samsung/include/plat/gpio-core.h
>> index e358c7d..c8681e0 100644
>> --- a/arch/arm/plat-samsung/include/plat/gpio-core.h
>> +++ b/arch/arm/plat-samsung/include/plat/gpio-core.h
>> @@ -14,6 +14,12 @@
>>  #define GPIOCON_OFF  (0x00)
>>  #define GPIODAT_OFF  (0x04)
>>
>> +#define S5P_GPIO_LEVEL_LOW           (0x00)
>> +#define S5P_GPIO_LEVEL_HIGH          (0x01)
>> +#define S5P_GPIO_EDGE_FALLING                (0x02)
>> +#define S5P_GPIO_EDGE_RISING         (0x03)
>> +#define S5P_GPIO_EDGE_BOTH           (0x04)
>
> Why should we change the name of definition from S5P_EXTINT_XXX?
> If we use that, we don't need to change other files.

External interrupt is one of GPIOs. and it's used for GPIO interrupt.
Do you want to use the EXTINT at generic gpio function?

Also change the name format as IRQ_TYPE_* style.

Thank you,
Kyungmin Park

>
>> +
>>  #define con_4bit_shift(__off) ((__off) * 4)
>>
>>  /* Define the core gpiolib support functions that the s3c platforms may
>> --
>
> Thanks.
>
> Best regards,
> Kgene.
> --
> Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
> SW Solution Development Team, Samsung Electronics Co., Ltd.
>
>

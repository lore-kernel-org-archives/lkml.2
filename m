Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756931Ab0FCRDj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 13:03:39 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:49535 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756842Ab0FCRDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 13:03:36 -0400
Message-ID: <4C07E047.4090401@metafoo.de>
Date: Thu, 03 Jun 2010 19:03:03 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: Florian Fainelli <florian@openwrt.org>
CC: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 01/26] MIPS: Add base support for Ingenic JZ4740
 System-on-a-Chip
References: <1275505397-16758-1-git-send-email-lars@metafoo.de> <1275505397-16758-2-git-send-email-lars@metafoo.de> <201006031627.31308.florian@openwrt.org>
In-Reply-To: <201006031627.31308.florian@openwrt.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Florian

Florian Fainelli wrote:
> Hi Lars,
>
> On Wednesday 02 June 2010 21:02:52 Lars-Peter Clausen wrote:
>   
>> This patch adds a new cpu type for the JZ4740 to the Linux MIPS
>> architecture code. It also adds the iomem addresses for the different
>> components found on a JZ4740 SoC.
>>
>> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
>> ---
>>     
> [snip]
>
>   
>>  	 * MIPS64 class processors
>> diff --git a/arch/mips/include/asm/mach-jz4740/base.h
>> b/arch/mips/include/asm/mach-jz4740/base.h new file mode 100644
>> index 0000000..cba3aae
>> --- /dev/null
>> +++ b/arch/mips/include/asm/mach-jz4740/base.h
>> @@ -0,0 +1,28 @@
>> +#ifndef __ASM_MACH_JZ4740_BASE_H__
>> +#define __ASM_MACH_JZ4740_BASE_H__
>> +
>> +#define JZ4740_CPM_BASE_ADDR	0xb0000000
>> +#define JZ4740_INTC_BASE_ADDR	0xb0001000
>> +#define JZ4740_TCU_BASE_ADDR	0xb0002000
>> +#define JZ4740_WDT_BASE_ADDR	0xb0002000
>> +#define JZ4740_RTC_BASE_ADDR	0xb0003000
>> +#define JZ4740_GPIO_BASE_ADDR	0xb0010000
>> +#define JZ4740_AIC_BASE_ADDR	0xb0020000
>> +#define JZ4740_ICDC_BASE_ADDR	0xb0020000
>> +#define JZ4740_MSC_BASE_ADDR	0xb0021000
>> +#define JZ4740_UART0_BASE_ADDR	0xb0030000
>> +#define JZ4740_UART1_BASE_ADDR	0xb0031000
>> +#define JZ4740_I2C_BASE_ADDR	0xb0042000
>> +#define JZ4740_SSI_BASE_ADDR	0xb0043000
>> +#define JZ4740_SADC_BASE_ADDR	0xb0070000
>> +#define JZ4740_EMC_BASE_ADDR	0xb3010000
>> +#define JZ4740_DMAC_BASE_ADDR	0xb3020000
>> +#define JZ4740_UHC_BASE_ADDR	0xb3030000
>> +#define JZ4740_UDC_BASE_ADDR	0xb3040000
>> +#define JZ4740_LCD_BASE_ADDR	0xb3050000
>> +#define JZ4740_SLCD_BASE_ADDR	0xb3050000
>> +#define JZ4740_CIM_BASE_ADDR	0xb3060000
>> +#define JZ4740_IPU_BASE_ADDR	0xb3080000
>> +#define JZ4740_ETH_BASE_ADDR	0xb3100000
>>     
>
> Any reasons why you prefered virtual addresses here instead of physical ones?
> You might also want to define a "true" base address and compute the registers
> offset relatively to this base address for better clarity.
>
>   
This is historically grown and I agree that I should rather use the
physical addresses here, especially because they are only used together
with CPHYSADDR everywhere now.

Thanks for reviewing
- Lars

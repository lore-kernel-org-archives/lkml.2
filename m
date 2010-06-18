Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761249Ab0FRNJn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 09:09:43 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:36382 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761236Ab0FRNJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 09:09:42 -0400
Message-ID: <4C1B6FF8.1060504@atmel.com>
Date: Fri, 18 Jun 2010 15:09:12 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.1.9) Gecko/20100317 Lightning/1.0b1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@mvista.com>
CC: akpm@linux-foundation.org, linux-arm-kernel@lists.infradead.org,
       avictor.za@gmail.com, haavard.skinnemoen@atmel.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: some Atmel drivers change maintainer
References: <1276694487-20065-1-git-send-email-nicolas.ferre@atmel.com> <4C1B518F.4090307@ru.mvista.com>
In-Reply-To: <4C1B518F.4090307@ru.mvista.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 18/06/2010 12:59, Sergei Shtylyov :
> Hello.
> 
> Nicolas Ferre wrote:
> 
>> I take over the maintenance of SPI, USART, Ethernet and USB gadget
>> drivers.
>> Those drivers are found in Atmel microcontrollers, both AT32/AVR32 and
>> AT91/ARM.
> 
>> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>> Acked-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
>> ---
>>  MAINTAINERS |   10 +++++-----
>>  1 files changed, 5 insertions(+), 5 deletions(-)
> 
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 6d119c9..5f71809 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -1148,7 +1148,7 @@ F:    drivers/mmc/host/atmel-mci.c
> [...]
>>  ATMEL USBA UDC DRIVER
>> -M:    Haavard Skinnemoen <hskinnemoen@atmel.com>
>> -L:    kernel@avr32linux.org
>> +M:    Nicolas Ferre <nicolas.ferre@atmel.com>
>> +L:    linux-arm-kernel@lists.infradead.org (moderated for
>> non-subscribers)
> 
>    Not linux-usb@vger.kernel.org?

The problem is that I am not subscribing to it at the moment...
Maybe I should add it to the USBA driver entry...

Best regards,
-- 
Nicolas Ferre


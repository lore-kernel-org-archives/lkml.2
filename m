Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960Ab0IJJvs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 05:51:48 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:6471 "EHLO sjogate2.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751689Ab0IJJvr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 05:51:47 -0400
Message-ID: <4C89FFAA.3010503@atmel.com>
Date: Fri, 10 Sep 2010 11:51:38 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.2.9) Gecko/20100825 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        avictor.za@gmail.com
Subject: Re: [PATCH] AT91: dm9000 initialization update
References: <1284113629-13768-1-git-send-email-nicolas.ferre@atmel.com> <20100910092344.GN9112@game.jcrosoft.org>
In-Reply-To: <20100910092344.GN9112@game.jcrosoft.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 10/09/2010 11:23, Jean-Christophe PLAGNIOL-VILLARD :
> On 12:13 Fri 10 Sep     , Nicolas Ferre wrote:
>> Add information in dm9000 mac/phy chip initialization:
>> - irq resource details
>> - platform data details
>>
>> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>> ---
>>  arch/arm/mach-at91/board-sam9261ek.c |    3 ++-
>>  1 files changed, 2 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/arm/mach-at91/board-sam9261ek.c b/arch/arm/mach-at91/board-sam9261ek.c
>> index c4c8865..b4307ab 100644
>> --- a/arch/arm/mach-at91/board-sam9261ek.c
>> +++ b/arch/arm/mach-at91/board-sam9261ek.c
>> @@ -93,11 +93,12 @@ static struct resource dm9000_resource[] = {
>>  		.start	= AT91_PIN_PC11,
>>  		.end	= AT91_PIN_PC11,
>>  		.flags	= IORESOURCE_IRQ
>> +			| IORESOURCE_IRQ_LOWEDGE | IORESOURCE_IRQ_HIGHEDGE,
> both?

Yes, only configuration supported by GPIO irqs...

Regards,
-- 
Nicolas Ferre


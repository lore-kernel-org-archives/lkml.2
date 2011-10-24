Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827Ab1JXOdJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 10:33:09 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:10677 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755732Ab1JXOdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 10:33:08 -0400
Message-ID: <4EA57705.6060103@atmel.com>
Date: Mon, 24 Oct 2011 16:32:37 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Baruch Siach <baruch@tkos.co.il>
CC: robherring2@gmail.com, grant.likely@secretlab.ca,
        devicetree-discuss@lists.ozlabs.org, plagnioj@jcrosoft.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V3 1/2] ARM: at91: dt: at91sam9g45 family and board device
 tree files
References: <4E9F8226.4030503@gmail.com> <15ab652499e7f6f8a26724bfd90643a8f3f96ad9.1319464310.git.nicolas.ferre@atmel.com> <20111024141253.GF26649@sapphire.tkos.co.il>
In-Reply-To: <20111024141253.GF26649@sapphire.tkos.co.il>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2011 04:12 PM, Baruch Siach :
> Hi Nicolas,
> 
> On Mon, Oct 24, 2011 at 04:05:00PM +0200, Nicolas Ferre wrote:
>> Create a new device tree source file for Atmel at91sam9g45 SoC family.
>> The Evaluation Kit at91sam9m10g45ek includes it.
>> This first basic support will be populated as drivers and boards will be
>> converted to device tree.
>> Contains serial, dma and interrupt controllers.
>>
>> The generic board file still takes advantage of platform data for early serial
>> init. As we need a storage media and the NAND flash driver is not converted to
>> DT yet, we keep old initialization for it.
>>
>> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>> ---
> 
> [snip]
> 
>> +DT_MACHINE_START(at91sam9m10g45ek_dt, "Atmel AT91SAM (Device Tree)")
> 
> Since this is a generic AT91 machine descriptor, won't "at91sam_dt" be a more 
> appropriate name?

For sure that makes sense. I queue this change and make it appear only
in the pull request if it is the only change requested.

>> +	/* Maintainer: Atmel */
>> +	.timer		= &at91sam926x_timer,
>> +	.map_io		= at91_map_io,
>> +	.init_early	= ek_init_early,
>> +	.init_irq	= at91_dt_init_irq,
>> +	.init_machine	= at91_dt_device_init,
>> +	.dt_compat	= at91_dt_board_compat,
>> +MACHINE_END
> 
> baruch

Thanks for your review,

Best regards,
-- 
Nicolas Ferre

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803Ab1JYLHE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 07:07:04 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:59525 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006Ab1JYLHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 07:07:01 -0400
Message-ID: <4EA6983C.5080303@atmel.com>
Date: Tue, 25 Oct 2011 13:06:36 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: grant.likely@secretlab.ca, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, plagnioj@jcrosoft.com
Subject: Re: [PATCH V3 1/2] ARM: at91: dt: at91sam9g45 family and board device
 tree files
References: <4E9F8226.4030503@gmail.com> <15ab652499e7f6f8a26724bfd90643a8f3f96ad9.1319464310.git.nicolas.ferre@atmel.com> <4EA579E7.7000002@gmail.com>
In-Reply-To: <4EA579E7.7000002@gmail.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2011 04:44 PM, Rob Herring :
> On 10/24/2011 09:05 AM, Nicolas Ferre wrote:
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
> 
> This comment is out of date for serial.

Well, not for early serial actually.

>> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>> ---
>> V3:
>> - additional clock lookup for device tree handling
>> - devices disabled in dtsi file so that only useful devices are
>>   enabled in dts files
>>
>> V2: foundation for AT91SAM generic support
>> - device tree focused board file
>> - inclusion of USART DT support
>> - early USART and NAND still using platform data
>>
> 
> Reviewed-by: Rob Herring <rob.herring@calxeda.com>

Thanks Rob for your review. I send a pull request to Arnd on this material.

Best regards,
-- 
Nicolas Ferre

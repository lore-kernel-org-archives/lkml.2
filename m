Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab1HHT7u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 15:59:50 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:62362 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408Ab1HHT7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 15:59:50 -0400
Message-ID: <4E40401F.4030309@atmel.com>
Date: Mon, 08 Aug 2011 20:59:27 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [RFC PATCH 2/2] AT91: dt: simple device tree support for at91sam9g45
 family
References: <56092075210001f40db485e0b126fe7c0c7b75ac.1312560476.git.nicolas.ferre@atmel.com> <bdd7c02a561bc0655e9dfd4586f42774f2347ca1.1312560476.git.nicolas.ferre@atmel.com> <20110807035751.GC7667@ponder.secretlab.ca>
In-Reply-To: <20110807035751.GC7667@ponder.secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2011 04:57 AM, Grant Likely wrote:
> On Fri, Aug 05, 2011 at 05:24:53PM +0100, Nicolas Ferre wrote:
>> Add basic device tree support for at91sam9g45 SoC family and the
>> at91sam9m10g45ek board.
>> DT is been used to describe the at91sam9g45 SoC memory and AIC. It also
>> adds the dmaengine driver.
>>
>> Signed-off-by: Nicolas Ferre<nicolas.ferre@atmel.com>
>
> Hi Nicolas,
>
> Looks like a great start.  I was glad we could work on this last week.

Yes, that was enriching.

> Some comments below.

I will have to rework this series for sure but I have limited access to 
my git tree/emails this week... I plan to come back to this next week.

>> ---
>>   arch/arm/mach-at91/Kconfig               |    8 ++++++
>>   arch/arm/mach-at91/Makefile.boot         |    2 +
>>   arch/arm/mach-at91/at91sam9g45_devices.c |    3 +-
>>   arch/arm/mach-at91/board-sam9m10g45ek.c  |   36 ++++++++++++++++++++++++++++++
>>   4 files changed, 48 insertions(+), 1 deletions(-)

[..]

Best regards,
-- 
Nicolas Ferre

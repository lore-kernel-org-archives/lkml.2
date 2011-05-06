Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801Ab1EFMcA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 08:32:00 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:39109 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288Ab1EFMb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 08:31:59 -0400
Message-ID: <4DC3EA35.5030709@atmel.com>
Date: Fri, 06 May 2011 14:31:49 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
CC: kernel@avr32linux.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] avr32: add some more at91 to cpu.h definition
References: <1304680123-20218-1-git-send-email-nicolas.ferre@atmel.com> <1304683480.3025.2.camel@hcegtvedt.norway.atmel.com>
In-Reply-To: <1304683480.3025.2.camel@hcegtvedt.norway.atmel.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 06/05/2011 14:04, Hans-Christian Egtvedt :
> On Fri, 2011-05-06 at 13:08 +0200, Nicolas Ferre wrote:
>> Somme common drivers will need those at91 cpu_is_xxx() definitions.
>> Those definitions are already in Linus' tree so if we want to use them
>> in common drivers, we will need them in AVR32 cpu.h file.
>>
>> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> 
> Will you push this update for 2.6.39? I don't have anything for Linus
> right now.

Ah, Linus has just pulled from our tree...
Maybe we can wait a few days to see if some fixes have to be pushed
upstream before -final...

> Acked-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
> with one comment...

;-)

>> ---
>>  arch/avr32/mach-at32ap/include/mach/cpu.h |   13 +++++++++++++
>>  1 files changed, 13 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/avr32/mach-at32ap/include/mach/cpu.h b/arch/avr32/mach-at32ap/include/mach/cpu.h
>> index 9c96a13..a927d9e 100644
>> --- a/arch/avr32/mach-at32ap/include/mach/cpu.h
>> +++ b/arch/avr32/mach-at32ap/include/mach/cpu.h
>> @@ -31,8 +31,21 @@
>>  #define cpu_is_at91sam9263()	(0)
>>  #define cpu_is_at91sam9rl()	(0)
>>  #define cpu_is_at91cap9()	(0)
>> +#define cpu_is_at91cap9_revB()	(0)
>> +#define cpu_is_at91cap9_revC()	(0)
>>  #define cpu_is_at91sam9g10()	(0)
>> +#define cpu_is_at91sam9g20()	(0)
>>  #define cpu_is_at91sam9g45()	(0)
>>  #define cpu_is_at91sam9g45es()	(0)
>> +#define cpu_is_at91sam9m10()	(0)
>> +#define cpu_is_at91sam9g46()	(0)
>> +#define cpu_is_at91sam9m11()	(0)
>> +#define cpu_is_at91sam9x5()	(0)
>> +#define cpu_is_at91sam9g15()	(0)
>> +#define cpu_is_at91sam9g35()	(0)
>> +#define cpu_is_at91sam9x35()	(0)
>> +#define cpu_is_at91sam9g25()	(0)
>> +#define cpu_is_at91sam9x25()	(0)
>> +
> 
> No need for this extra newline.

True.

>>  #endif /* __ASM_ARCH_CPU_H */

Bye,
-- 
Nicolas Ferre


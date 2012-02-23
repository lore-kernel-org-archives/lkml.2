Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969Ab2BWJVQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 04:21:16 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62727 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753763Ab2BWJVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 04:21:13 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of rmallon@gmail.com designates 10.68.241.170 as permitted sender) smtp.mail=rmallon@gmail.com; dkim=pass header.i=rmallon@gmail.com
Message-ID: <4F46055B.9050308@gmail.com>
Date: Thu, 23 Feb 2012 20:22:35 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.27) Gecko/20120216 Thunderbird/3.1.19
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>
CC: plagnioj@jcrosoft.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux@arm.linux.org.uk
Subject: Re: [PATCH v2 11/19] ARM: at91/PMC: make register base soc independent
References: <1329903585-30738-1-git-send-email-nicolas.ferre@atmel.com> <bdea371b518c7b6d04ae1cfacacca2f75b191984.1329903206.git.nicolas.ferre@atmel.com> <4F457128.6060407@gmail.com> <4F45FAF7.3080409@atmel.com>
In-Reply-To: <4F45FAF7.3080409@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/02/12 19:38, Nicolas Ferre wrote:

> On 02/22/2012 11:50 PM, Ryan Mallon :
>> On 22/02/12 20:39, Nicolas Ferre wrote:
>>
>>> From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
>>>
>>> Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
>>> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>>> Reviewed-by: Ryan Mallon <rmallon@gmail.com>
>>> ---
>>
>> <snip>
>>
>>> -	seq_printf(s, "SCSR = %8x\n", scsr = at91_sys_read(AT91_PMC_SCSR));
>>> -	seq_printf(s, "PCSR = %8x\n", pcsr = at91_sys_read(AT91_PMC_PCSR));
>>> -	seq_printf(s, "MOR  = %8x\n", at91_sys_read(AT91_CKGR_MOR));
>>> -	seq_printf(s, "MCFR = %8x\n", at91_sys_read(AT91_CKGR_MCFR));
>>> -	seq_printf(s, "PLLA = %8x\n", at91_sys_read(AT91_CKGR_PLLAR));
>>> +	seq_printf(s, "SCSR = %8x\n", scsr = at91_pmc_read(AT91_PMC_SCSR));
>>> +	seq_printf(s, "PCSR = %8x\n", pcsr = at91_pmc_read(AT91_PMC_PCSR));
>>
>>
>> I realise the original code is wrong, so doesn't need to be fixed in
>> this patch, but can we please move the assignments out of the seq_printf
>> calls.
> 
> Well, I would not say "wrong". But ugly, for sure. I queue a patch to
> correct this just before this one.


Sorry, I meant ugly rather than wrong. When I first saw it, I thought your 
replace script had made a mistake :-). 

~Ryan

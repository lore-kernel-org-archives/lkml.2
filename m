Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134Ab0F2UGt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 16:06:49 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:63322 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755958Ab0F2UGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 16:06:47 -0400
Message-ID: <4C2A5189.60508@kernel.org>
Date: Tue, 29 Jun 2010 13:03:21 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH 03/25] lmb: Print new doubled array location info
References: <1277227614-11581-1-git-send-email-yinghai@kernel.org> <1277227614-11581-4-git-send-email-yinghai@kernel.org> <201006291144.14469.bjorn.helgaas@hp.com>
In-Reply-To: <201006291144.14469.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4C2A521D.014E,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2010 10:44 AM, Bjorn Helgaas wrote:
> On Tuesday, June 22, 2010 11:26:32 am Yinghai Lu wrote:
>> +	if (lmb_debug)
>> +		pr_info("lmb: %s array is doubled to %ld at %llx - %llx",
>> +			 lmb_type_name(type), type->max * 2, (u64)addr, (u64)addr + new_size);
> 
> Please print this memory range the same way we print resources, e.g.,
> "%#010llx-%#010llx", with "addr" and "addr + new_size - 1".

ok, I will put # for 0x.

but i like to have

xxx - yyy : to include end
[xxx, yyy - 1]

just like current e820 print out.
and it would be more readable without too many ffff

Thanks

Yinghai

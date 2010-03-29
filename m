Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447Ab0C2IaO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 04:30:14 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38556 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761Ab0C2IaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 04:30:12 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4BB06500.5060105@jp.fujitsu.com>
Date: Mon, 29 Mar 2010 17:29:52 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de
Subject: Re: [PATCH] x86: mce: Xeon75xx specific interface to get corrected
 memory error information v2
References: <20100324054044.GA4307@basil.fritz.box> <87vdcf7ent.fsf@basil.nowhere.org>
In-Reply-To: <87vdcf7ent.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/03/29 16:47), Andi Kleen wrote:
> Andi Kleen <andi@firstfloor.org> writes:
> 
>> x86: mce: Xeon75xx specific interface to get corrected memory error information v2
> 
> Ping?  Please review this patch. Thanks.
> -Andi
> 
>>
>> [This version addresses the previous comments. It does not change
>> any interface to the outside and does not attempt to encode DIMMs
>> or anything like that, but only passes out the physical address of u
>> a corrected error in the standard ADDR register field. 
>> So for the outside it looks exactly the same as if the CPU supported this 
>> natively, but no otherwise special interfaces.
>>
>> I hope this addresses previous concerns. I guess the DIMM error reporting
>> can be revisited once there's a new reporting interface. There are still
>> some traces of DIMM parsing in there, but it's only used for debug
>> purposes now.]
>>
>> ---
>>
>> Xeon 75xx doesn't log physical addresses on corrected machine check
>> events in the standard architectural MSRs. Instead the address has to
>> be retrieved in a model specific way. This makes it impossible
>> to do predictive failure analysis.

Could you point proper specification or datasheet to know/check what
you are going to do here?


Thanks,
H.Seto


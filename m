Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309Ab0H0TCi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 15:02:38 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:34307 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793Ab0H0TCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 15:02:36 -0400
Message-ID: <4C780B4E.9060800@kernel.org>
Date: Fri, 27 Aug 2010 12:00:30 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>
CC: Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v3] perf, x86: try to handle unknown nmis with running
 perfctrs
References: <9g472epksbkxhgmw6a3qh8r5.1282316687153@email.android.com> <20100820152510.GA4167@elte.hu> <20100823085339.GA26713@elte.hu> <20100826211424.GQ4879@redhat.com> <20100827081038.GF22783@erda.amd.com> <20100827185744.GV4879@redhat.com>
In-Reply-To: <20100827185744.GV4879@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2010 11:57 AM, Don Zickus wrote:
> On Fri, Aug 27, 2010 at 10:10:38AM +0200, Robert Richter wrote:
>>>  
>>>  	inc_irq_stat(apic_perf_irqs);
>>>  	ack = status;
>>> +	intel_pmu_ack_status(ack);
>>
>> I would slightly change the patch:
>>
>> There is no need for the ack variable anymore, you could directly work
>> with the status.
>>
>> I would call intel_pmu_ack_status() as close as possible after the
>> intel_pmu_get_status(), which is after 'again:'.
>>
> 
> Here is another version of the patch, which uses Robert's suggestion of
> removing the ack variable

Can you resend all three updated patches?

Thanks

Yinghai

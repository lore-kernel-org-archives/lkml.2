Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711Ab2F1QYI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 12:24:08 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:53255 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754671Ab2F1QYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 12:24:05 -0400
Message-ID: <4FEC84BD.6030304@linux.vnet.ibm.com>
Date: Thu, 28 Jun 2012 21:52:21 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Andrew Jones <drjones@redhat.com>
CC: Rik van Riel <riel@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Srikar <srikar@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Gleb Natapov <gleb@redhat.com>, chegu vinod <chegu_vinod@hp.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] kvm: handle last_boosted_vcpu = 0 case
References: <168f205d-d65f-4864-99c8-363b12818a9b@zmail17.collab.prod.int.phx2.redhat.com>
In-Reply-To: <168f205d-d65f-4864-99c8-363b12818a9b@zmail17.collab.prod.int.phx2.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12062816-4790-0000-0000-000003738B9D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2012 09:30 PM, Andrew Jones wrote:
>
>
> ----- Original Message -----
>> In summary, current PV has huge benefit on non-PLE machine.
>>
>> On PLE machine, the results become very sensitive to load, type of
>> workload and SPIN_THRESHOLD. Also PLE interference has significant
>> effect on them. But still it has slight edge over non PV.
>>
>
> Hi Raghu,
>
> sorry for my slow response. I'm on vacation right now (until the
> 9th of July) and I have limited access to mail.

Ok. Happy Vacation :)

Also, thanks for
> continuing the benchmarking. Question, when you compare PLE vs.
> non-PLE, are you using different machines (one with and one
> without), or are you disabling its use by loading the kvm module
> with the ple_gap=0 modparam as I did?

Yes, I am doing the same when I say with PLE disabled and comparing the
benchmarks (i.e loading kvm module with ple_gap=0).

But older non-PLE results were on a different machine altogether. (I
had limited access to PLE machine).



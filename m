Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759195Ab0FVJli (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 05:41:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759118Ab0FVJlg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 05:41:36 -0400
Message-ID: <4C208531.3040403@redhat.com>
Date: Tue, 22 Jun 2010 12:41:05 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
CC: LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Sheng Yang <sheng@linux.intel.com>,
       Marcelo Tosatti <mtosatti@redhat.com>, oerg Roedel <joro@8bytes.org>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, zhiteng.huang@intel.com,
       tim.c.chen@intel.com, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH V2 2/5] ara virt interface of perf to support kvm guest
 os statistics collection in guest os
References: <1277112686.2096.510.camel@ymzhang.sh.intel.com>	 <4C1F5452.3000107@redhat.com>	 <1277172510.2096.585.camel@ymzhang.sh.intel.com>	 <4C207E63.5010504@redhat.com> <1277198752.2096.721.camel@ymzhang.sh.intel.com>
In-Reply-To: <1277198752.2096.721.camel@ymzhang.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22/2010 12:25 PM, Zhang, Yanmin wrote:
>
>> I'm talking about the guest/host interface.  So you have one vmexit and
>> many host perf calls.
>>      
> I understood what you were speaking. I mean, perf generic codes operate perf_event
> one by one. At low layer, we just know one perf_event before calling hypercall to
> vmexit to host kernel.
>    

Ah.

We might fix that by having the perf ops work on guest memory, and add a 
commit that transfers them to the host.  But this is complicated and can 
be left for later.

-- 
error compiling committee.c: too many arguments to function


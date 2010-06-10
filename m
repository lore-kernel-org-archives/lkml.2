Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758379Ab0FJDGf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 23:06:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49989 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751496Ab0FJDGd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 23:06:33 -0400
Message-ID: <4C10569E.6020503@redhat.com>
Date: Thu, 10 Jun 2010 06:06:06 +0300
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
Subject: Re: [RFC] para virt interface of perf to support kvm guest os statistics
 collection in guest os
References: <1276054214.2096.383.camel@ymzhang.sh.intel.com>	 <4C0F51DD.3080200@redhat.com>	 <1276075280.2096.427.camel@ymzhang.sh.intel.com>	 <4C0F61D3.9000402@redhat.com> <1276136493.2096.462.camel@ymzhang.sh.intel.com>
In-Reply-To: <1276136493.2096.462.camel@ymzhang.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2010 05:21 AM, Zhang, Yanmin wrote:
>
>> I see.  So put it in a union.  Or perhaps not even in a union - what if
>> a kvm guest is also acting as a kvm host?
>>      
> My patch has consideration on it. I compiled kernel with host and guest support
> at the same time. The accessing to perf_event->shadow is really under specific
> scenarios, or they are just in specific functions. These functions are called
> just bu host kernel , or just by guest kernel.
>    

But a kernel can be both guest and host at the same time.  Currently 
this only works on AMD, but there was some work to bring it to Intel as 
well.


-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.


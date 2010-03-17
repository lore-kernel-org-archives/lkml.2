Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578Ab0CQIUx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 04:20:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20210 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753217Ab0CQIUu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 04:20:50 -0400
Message-ID: <4BA090CB.5020906@redhat.com>
Date: Wed, 17 Mar 2010 10:20:27 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Frank Ch. Eigler" <fche@redhat.com>,
       Anthony Liguori <aliguori@linux.vnet.ibm.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com
Subject: Re: [PATCH] Enhance perf to collect KVM guest os statistics from
 host side
References: <20100316133114.GB575@elte.hu> <y0mbpeo1f1y.fsf@fche.csb> <20100316155221.GA19699@elte.hu> <4B9FC11A.1070507@linux.vnet.ibm.com> <20100316175243.GC23859@elte.hu> <4B9FC8B2.6070404@linux.vnet.ibm.com> <20100316182809.GA26602@elte.hu> <4BA00E6A.7080903@linux.vnet.ibm.com> <20100317004136.GC17472@redhat.com> <4BA05285.3070903@redhat.com> <20100317081641.GE16374@elte.hu>
In-Reply-To: <20100317081641.GE16374@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17/2010 10:16 AM, Ingo Molnar wrote:
> * Avi Kivity<avi@redhat.com>  wrote:
>
>    
>> Monitoring guests from the host is useful for kvm developers, but less so
>> for users.
>>      
> Guest space profiling is easy, and 'perf kvm' is not about that. (plain 'perf'
> will work if a proper paravirt channel is opened to the host)
>
> I think you might have misunderstood the purpose and role of the 'perf kvm'
> patch here? 'perf kvm' is aimed at KVM developers: it is them who improve KVM
> code, not guest kernel users.
>    

Of course I understood it.  My point was that 'perf kvm' serves a tiny 
minority of users.  That doesn't mean it isn't useful, just that it 
doesn't satisfy all needs by itself.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.


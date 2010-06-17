Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910Ab0FQHbV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 03:31:21 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:65010 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755447Ab0FQHbU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 03:31:20 -0400
Message-ID: <4C19CE70.9000002@cn.fujitsu.com>
Date: Thu, 17 Jun 2010 15:27:44 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH 6/6] KVM: MMU: trace pte prefetch
References: <4C16E6ED.7020009@cn.fujitsu.com> <4C16E75F.6020003@cn.fujitsu.com> <4C16E7AD.1060101@cn.fujitsu.com> <4C16E7F4.5060801@cn.fujitsu.com> <4C16E82E.5010306@cn.fujitsu.com> <4C16E867.8040606@cn.fujitsu.com> <4C16E9AF.2090501@cn.fujitsu.com> <4C176D71.7060302@redhat.com>
In-Reply-To: <4C176D71.7060302@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Avi Kivity wrote:

>> @@ -2066,11 +2071,16 @@ static void direct_pte_prefetch(struct
>> kvm_vcpu *vcpu, u64 *sptep)
>>           pfn = gfn_to_pfn_atomic(vcpu->kvm, gfn);
>>           if (is_error_pfn(pfn)) {
>>               kvm_release_pfn_clean(pfn);
>> +            trace_pte_prefetch(true, PREFETCH_ERR_GFN2PFN);
>>               break;
>>           }
>>    
> 
> What about virtual addresses and gptes?  They can be helpful too.
> 

OK, will do it in the next version.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751094Ab2DREBN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 00:01:13 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:48084 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab2DREBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 00:01:12 -0400
Message-ID: <4F8E3C7F.5040601@linux.vnet.ibm.com>
Date: Wed, 18 Apr 2012 12:01:03 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 07/16] KVM: MMU: introduce for_each_pte_list_spte
References: <4F87FA69.5060106@linux.vnet.ibm.com> <4F87FC19.8080404@linux.vnet.ibm.com> <20120414114422.e3fe6e2abbfdcce61e6f69c8@gmail.com> <4F8B93B9.2030801@linux.vnet.ibm.com> <20120417234731.a19f270d5701b11ce95d13d4@gmail.com>
In-Reply-To: <20120417234731.a19f270d5701b11ce95d13d4@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12041804-5564-0000-0000-0000023F0C8E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2012 10:47 PM, Takuya Yoshikawa wrote:

> On Mon, 16 Apr 2012 11:36:25 +0800
> Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com> wrote:
> 
>> I tested it with kernbench, no regression is found.
> 
> Because kernbench is not at all good test for this.
> 
>> It is not a problem since the iter and spte should be in the cache.
> 
> I have checked dirty-log-perf myself with this patch [01-07].
> 
> GET_DIRTY_LOG for 1GB dirty pages has become more than 15% slower.
> 


Thanks for your test!

Unbelievable, i will do more test and check it more carefully.

Could you please open your tool, then i can reproduction it and find the
real reason?

> 
> Note: if you had checked the worst case latency with this patch series,
> you should have noticed this regression by yourself.
> 
> Auto-test and kernbench are not enough to see the effect of this work.
> 


I will check whether your tool is better then kernbench/autotest after
review your tool.


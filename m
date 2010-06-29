Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432Ab0F2BWK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 21:22:10 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49409 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751365Ab0F2BWG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 21:22:06 -0400
Message-ID: <4C2949DC.4070201@cn.fujitsu.com>
Date: Tue, 29 Jun 2010 09:18:20 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 7/10] KVM: MMU: introduce mmu_topup_memory_cache_atomic()
References: <4C2498EC.2010006@cn.fujitsu.com> <4C249BDE.9050701@cn.fujitsu.com> <4C2884BC.2070804@redhat.com>
In-Reply-To: <4C2884BC.2070804@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Avi Kivity wrote:
> On 06/25/2010 03:06 PM, Xiao Guangrong wrote:
>> Introduce mmu_topup_memory_cache_atomic(), it support topup memory
>> cache in atomic context
>>
>>    
> 
> Can instead preallocate enough for all prefetches, isn't it simpler?

Good idea, will do it in the next version, thanks.

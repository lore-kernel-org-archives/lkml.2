Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756370Ab1LWEHN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 23:07:13 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:46706 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753768Ab1LWEHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 23:07:09 -0500
Message-ID: <4EF3FE64.4070102@linux.vnet.ibm.com>
Date: Fri, 23 Dec 2011 12:07:00 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 8/8] KVM: MMU: remove PT64_SECOND_AVAIL_BITS_SHIFT
References: <4EEB19AF.5070501@linux.vnet.ibm.com> <4EEB1AFB.1090806@linux.vnet.ibm.com> <4EEDC396.8090600@redhat.com>
In-Reply-To: <4EEDC396.8090600@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 11122304-9574-0000-0000-000000A2E77E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2011 06:42 PM, Avi Kivity wrote:

> On 12/16/2011 12:18 PM, Xiao Guangrong wrote:
>> It is not used, remove it
>>
>> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
>> ---
>>  arch/x86/kvm/mmu.c |    1 -
>>  1 files changed, 0 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
>> index 5d0f0e3..234a32e 100644
>> --- a/arch/x86/kvm/mmu.c
>> +++ b/arch/x86/kvm/mmu.c
>> @@ -91,7 +91,6 @@ module_param(dbg, bool, 0644);
>>  #define PTE_PREFETCH_NUM		8
>>
>>  #define PT_FIRST_AVAIL_BITS_SHIFT 9
>> -#define PT64_SECOND_AVAIL_BITS_SHIFT 52
>>
>>
> 
> Don't see a reason to drop it, we may use it some day.
> 


Anyway, it is not used in currently code, I do not have strong opinion on it :)
Please ignore it if you do not like.


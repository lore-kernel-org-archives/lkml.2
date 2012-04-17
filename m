Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755754Ab2DQD43 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 23:56:29 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:34713 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670Ab2DQD42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 23:56:28 -0400
Message-ID: <4F8CE9CF.6050506@linux.vnet.ibm.com>
Date: Tue, 17 Apr 2012 11:55:59 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 10/16] KVM: MMU: fask check whether page is writable
References: <4F87FA69.5060106@linux.vnet.ibm.com> <4F87FC82.2050302@linux.vnet.ibm.com> <4F8AE64F.7080909@redhat.com> <4F8B9115.2030807@linux.vnet.ibm.com> <4F8BEE1B.8000704@redhat.com> <4F8BF265.7020405@linux.vnet.ibm.com> <4F8C06ED.6020805@redhat.com>
In-Reply-To: <4F8C06ED.6020805@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12041617-1396-0000-0000-000000FD3572
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2012 07:47 PM, Avi Kivity wrote:

> On 04/16/2012 01:20 PM, Xiao Guangrong wrote:
>>>>
>>>> It is used to avoid the unnecessary overload 
>>>
>>> It's overloading me :(
>>>
>>
>>
>> Sorry.
>>
> 
> The trick is to send those in separate patchset so the maintainer
> doesn't notice.
> 


Thanks for your suggestion, i will pay more attention on it in the
further.

For this patch, what did you mean of "those"? You mean the whole
rmap.PTE_LIST_WP_BIT (fast check for shadow page table write protection
and host write protection) or just about host_page_write_protect
(for KSM only)?

If we do not have rmap.PTE_LIST_WP_BIT, there may have regression on
shadow mmu.

Hmm, do i need implement rmap.PTE_LIST_WP_BIT, then fast page fault?


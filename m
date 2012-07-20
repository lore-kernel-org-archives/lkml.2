Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752436Ab2GTDqi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 23:46:38 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:56073 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054Ab2GTDqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 23:46:37 -0400
Message-ID: <5008D477.2020007@linux.vnet.ibm.com>
Date: Fri, 20 Jul 2012 11:45:59 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 5/9] KVM: MMU: fask check write-protect for direct mmu
References: <50056DB8.7080702@linux.vnet.ibm.com> <50056E59.4090003@linux.vnet.ibm.com> <20120720003917.GA8951@amt.cnet>
In-Reply-To: <20120720003917.GA8951@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12071917-1396-0000-0000-00000194EB22
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BTW, they are some bug fix patches on -master branch, but
it is not existed on -next branch:
commit: f411930442e01f9cf1bf4df41ff7e89476575c4d
commit: 85b7059169e128c57a3a8a3e588fb89cb2031da1

It causes code conflict if we do the development on -next.

On 07/20/2012 08:39 AM, Marcelo Tosatti wrote:can
> On Tue, Jul 17, 2012 at 09:53:29PM +0800, Xiao Guangrong wrote:
>> If it have no indirect shadow pages we need not protect any gfn,
>> this is always true for direct mmu without nested
>>
>> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> 
> Xiao,
> 
> What is the motivation? Numbers please.
> 
> In fact, what case was the original indirect_shadow_pages conditional in
> kvm_mmu_pte_write optimizing again?
> 
> 
> 



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935063Ab2DMK1f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 06:27:35 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:46299 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755035Ab2DMK1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 06:27:34 -0400
Message-ID: <4F87FF6C.1080403@linux.vnet.ibm.com>
Date: Fri, 13 Apr 2012 18:26:52 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Xiao Guangrong <xiaoguangrong.eric@gmail.com>, Avi Kivity <avi@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 08/13] KVM: MMU: fask check whether page is writable
References: <4F742951.7080003@linux.vnet.ibm.com> <4F742A74.1050304@linux.vnet.ibm.com> <4F7879A1.2020301@redhat.com> <4F7DDC6C.90304@gmail.com> <20120412230828.GA20207@amt.cnet>
In-Reply-To: <20120412230828.GA20207@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12041310-4790-0000-0000-0000022C57E3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/13/2012 07:08 AM, Marcelo Tosatti wrote:


>> Yes, it is used as a cache for mmu_need_write_protect.
>>
>> When the gfn is protected by sync sp or read-only host page we set this bit,
>> and it is be cleared when the sp become unsync or host page becomes writable.
> 
> Wouldnt dropping support for shadow entirely make it much simpler? 
> 
> The idea to handle RO->RW without mmu_lock is very neat, but the
> complexity with shadow is horrible.
> 


I have posted the v2 that is fairly simple, please review that one. :)
Thank you, Marcelo!


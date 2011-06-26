Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912Ab1FZImr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 04:42:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43792 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470Ab1FZImk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 04:42:40 -0400
Message-ID: <4E06F0F8.6050009@redhat.com>
Date: Sun, 26 Jun 2011 11:42:32 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 21/22] KVM: MMU: mmio page fault support
References: <4E01FBC9.3020009@cn.fujitsu.com> <4E01FDE0.5080800@cn.fujitsu.com> <20110622215940.GA30064@amt.cnet> <4E02B0BE.7070003@cn.fujitsu.com> <20110623142134.GA12181@amt.cnet> <4E037E21.6010203@cn.fujitsu.com>
In-Reply-To: <4E037E21.6010203@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2011 08:55 PM, Xiao Guangrong wrote:
> Anyway, mmio spte is needed to detect bugs for hard mmu
>

Note, we have the equivalent problem with bypass_guest_pf=1 and it works 
fine.  We did have an issue with EPT due to a missing tlb flush, but we 
don't need to design the whole mmu around it.

-- 
error compiling committee.c: too many arguments to function


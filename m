Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395Ab0DLI5n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 04:57:43 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61533 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752701Ab0DLI5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 04:57:41 -0400
Message-ID: <4BC2DFEC.5020204@cn.fujitsu.com>
Date: Mon, 12 Apr 2010 16:55:08 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/6] KVM MMU: optimize/cleanup for marking parent unsync
References: <4BC2D2E2.1030604@cn.fujitsu.com> <4BC2D390.7050708@cn.fujitsu.com> <4BC2DAB5.4030901@redhat.com>
In-Reply-To: <4BC2DAB5.4030901@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Avi Kivity wrote:
> On 04/12/2010 11:02 AM, Xiao Guangrong wrote:
>> - 'vcpu' is not used while mark parent unsync, so remove it
>> - if it has alread marked unsync, no need to walk it's parent
>>
>>    
> 
> Please separate these two changes.
> 
> The optimization looks good.  Perhaps it can be done even nicer using
> mutually recursive functions (mmu_parent_walk calls mmu_parent_walk_fn
> which calls mmu_parent_walk on the parent), but let's not change too
> many things at a time.

OK, i'll separate it in the next version

Thanks,
Xiao

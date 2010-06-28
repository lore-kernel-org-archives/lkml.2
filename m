Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864Ab0F1LRV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 07:17:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23225 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179Ab0F1LRU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 07:17:20 -0400
Message-ID: <4C2884BC.2070804@redhat.com>
Date: Mon, 28 Jun 2010 14:17:16 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 7/10] KVM: MMU: introduce mmu_topup_memory_cache_atomic()
References: <4C2498EC.2010006@cn.fujitsu.com> <4C249BDE.9050701@cn.fujitsu.com>
In-Reply-To: <4C249BDE.9050701@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2010 03:06 PM, Xiao Guangrong wrote:
> Introduce mmu_topup_memory_cache_atomic(), it support topup memory
> cache in atomic context
>
>    

Can instead preallocate enough for all prefetches, isn't it simpler?

-- 
error compiling committee.c: too many arguments to function


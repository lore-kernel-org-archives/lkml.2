Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932731Ab2GKNwF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 09:52:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27797 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932560Ab2GKNwA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 09:52:00 -0400
Message-ID: <4FFD84FB.80600@redhat.com>
Date: Wed, 11 Jul 2012 16:51:55 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v7 00/10] KVM: MMU: fast page fault
References: <4FE1822D.8010002@linux.vnet.ibm.com>
In-Reply-To: <4FE1822D.8010002@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2012 10:56 AM, Xiao Guangrong wrote:
> Changlog:
> - always atomicly update the spte if it can be updated out of mmu-lock
> - rename spte_can_be_writable() to spte_is_locklessly_modifiable()
> - cleanup and comment spte_write_protect()
> 
> Performance result:
> (The benchmark can be found at: http://www.spinics.net/lists/kvm/msg73011.html)
> 
>                                before            after
> Run 10 times, Avg time:      538233957 ns.      249809853 ns. +53.6%
> 

Thanks, all applied.  Thanks for your patience while we reviewed all the
iterations of this patchset.

-- 
error compiling committee.c: too many arguments to function



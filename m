Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751683Ab1LRKmh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 05:42:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39127 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751371Ab1LRKme (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 05:42:34 -0500
Message-ID: <4EEDC396.8090600@redhat.com>
Date: Sun, 18 Dec 2011 12:42:30 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 8/8] KVM: MMU: remove PT64_SECOND_AVAIL_BITS_SHIFT
References: <4EEB19AF.5070501@linux.vnet.ibm.com> <4EEB1AFB.1090806@linux.vnet.ibm.com>
In-Reply-To: <4EEB1AFB.1090806@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2011 12:18 PM, Xiao Guangrong wrote:
> It is not used, remove it
>
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  arch/x86/kvm/mmu.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 5d0f0e3..234a32e 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -91,7 +91,6 @@ module_param(dbg, bool, 0644);
>  #define PTE_PREFETCH_NUM		8
>
>  #define PT_FIRST_AVAIL_BITS_SHIFT 9
> -#define PT64_SECOND_AVAIL_BITS_SHIFT 52
>
>

Don't see a reason to drop it, we may use it some day.

-- 
error compiling committee.c: too many arguments to function


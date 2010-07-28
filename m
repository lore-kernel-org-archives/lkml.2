Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419Ab0G1PFp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 11:05:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1681 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755394Ab0G1PFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 11:05:42 -0400
Date: Tue, 27 Jul 2010 22:22:17 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: MMU: remove valueless output message
Message-ID: <20100728012217.GE7327@amt.cnet>
References: <4C4E50AE.3050902@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C4E50AE.3050902@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 27, 2010 at 11:21:18AM +0800, Xiao Guangrong wrote:
> After commit 53383eaad08d, the '*spte' has updated before call
> rmap_remove()(in most case it's 'shadow_trap_nonpresent_pte'), so
> remove this information from error message
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  arch/x86/kvm/mmu.c |   11 +++++------
>  1 files changed, 5 insertions(+), 6 deletions(-)

Applied, thanks.


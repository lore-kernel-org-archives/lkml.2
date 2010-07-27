Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467Ab0G1PFv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 11:05:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54067 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754687Ab0G1PFq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 11:05:46 -0400
Date: Tue, 27 Jul 2010 18:40:31 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Avi Kivity <avi@redhat.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: fix compile warning
Message-ID: <20100727214031.GB12889@amt.cnet>
References: <20100726151405.2dfd20ee.sfr@canb.auug.org.au>
 <4C4D216B.5040004@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C4D216B.5040004@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 26, 2010 at 01:47:23PM +0800, Xiao Guangrong wrote:
> 
> Stephen Rothwell wrote:
> > Hi all,
> > 
> > After merging the kvm tree, today's linux-next build (x86_64
> > allmodconfig) produced this warning:
> > 
> > arch/x86/kvm/mmu.c: In function 'kvm_mmu_pte_write':
> > arch/x86/kvm/mmu.c:2908: warning: suggest parentheses around operand of '!' or change '&' to '&&' or '!' to '~'
> > 
> > Introduced by commit af8720393c71a8f81ade71c404798d80c68c5d73 ("KVM: MMU:
> > add missing reserved bits check in speculative path").
> 
> Hi Stephen,
> 
> Thanks for your report, this patch can fix it.
> 
> Subject: [PATCH] KVM: fix compile warning
> 
> Fix:
> arch/x86/kvm/mmu.c: In function 'kvm_mmu_pte_write':
> arch/x86/kvm/mmu.c:2908: warning: suggest parentheses around operand of '!' or change '&' to '&&' or '!' to '~'
> 
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  arch/x86/kvm/mmu.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)

Applied, thanks.


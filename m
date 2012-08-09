Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759328Ab2HITKk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 15:10:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27224 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759222Ab2HITJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 15:09:26 -0400
Date: Thu, 9 Aug 2012 15:50:47 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v5 03/12] KVM: introduce gfn_to_pfn_memslot_atomic
Message-ID: <20120809185047.GB20889@amt.cnet>
References: <5020E423.9080004@linux.vnet.ibm.com>
 <5020E4B0.9090609@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5020E4B0.9090609@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2012 at 05:49:36PM +0800, Xiao Guangrong wrote:
> It can instead of hva_to_pfn_atomic
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  arch/x86/kvm/mmu.c       |    5 +----
>  include/linux/kvm_host.h |    3 ++-
>  virt/kvm/kvm_main.c      |   14 ++++++++------
>  3 files changed, 11 insertions(+), 11 deletions(-)

What if someone needs gfn_to_hva_memslot in the future, which is not
unlikely?


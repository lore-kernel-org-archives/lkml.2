Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108Ab2AILe6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 06:34:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21417 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753719Ab2AILe5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 06:34:57 -0500
Date: Mon, 9 Jan 2012 09:33:54 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 7/8] KVM: MMU: remove the redundant get_written_sptes
Message-ID: <20120109113354.GC5255@amt.cnet>
References: <4EEB19AF.5070501@linux.vnet.ibm.com>
 <4EEB1AE2.1000300@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EEB1AE2.1000300@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 16, 2011 at 06:18:10PM +0800, Xiao Guangrong wrote:
> get_written_sptes is called twice in kvm_mmu_pte_write, one of them can be
> removed
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  arch/x86/kvm/mmu.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)

Applied, thanks.


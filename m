Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932510Ab0FKUfV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 16:35:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29633 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660Ab0FKUfS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 16:35:18 -0400
Date: Fri, 11 Jun 2010 17:14:20 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH 4/7] KVM: MMU: don't mark pte notrap if it's just sync
 transient
Message-ID: <20100611201420.GD12317@amt.cnet>
References: <4C1239EE.3090904@cn.fujitsu.com>
 <4C123ABA.3000601@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C123ABA.3000601@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 11, 2010 at 09:31:38PM +0800, Xiao Guangrong wrote:
> If the sync-sp just sync transient, don't mark its pte notrap
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  arch/x86/include/asm/kvm_host.h |    2 +-
>  arch/x86/kvm/mmu.c              |   11 ++++-------
>  arch/x86/kvm/paging_tmpl.h      |    5 +++--
>  3 files changed, 8 insertions(+), 10 deletions(-)

Xiao,

Can you explain the reasoning for this? 


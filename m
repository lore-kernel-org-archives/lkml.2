Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348Ab2AILfD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 06:35:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2098 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753732Ab2AILfB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 06:35:01 -0500
Date: Mon, 9 Jan 2012 09:30:05 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/8] KVM: MMU: set the dirty bit for the upper shadow page
Message-ID: <20120109113005.GB5255@amt.cnet>
References: <4EEB19AF.5070501@linux.vnet.ibm.com>
 <4EEB1A00.8090707@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EEB1A00.8090707@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 16, 2011 at 06:14:24PM +0800, Xiao Guangrong wrote:
> Upper page do not need to be tracked the status bit, it is safe to set the
> dirty and let cpu to happily prefetch it
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  arch/x86/kvm/mmu.c |   13 +++++--------
>  1 files changed, 5 insertions(+), 8 deletions(-)

Dirty bit is ignored in non-leaf pagetable entries.


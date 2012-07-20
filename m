Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752913Ab2GTAtc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 20:49:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13360 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752690Ab2GTAsc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 20:48:32 -0400
Date: Thu, 19 Jul 2012 21:09:31 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 4/9] KVM: MMU: track the refcount when unmap the page
Message-ID: <20120720000931.GC7121@amt.cnet>
References: <50056DB8.7080702@linux.vnet.ibm.com>
 <50056E34.8080505@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50056E34.8080505@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2012 at 09:52:52PM +0800, Xiao Guangrong wrote:
> It will trigger a WARN_ON if the page has been freed but it is still
> used in mmu, it can help us to detect mm bug early
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  arch/x86/kvm/mmu.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)

Applied, thanks.


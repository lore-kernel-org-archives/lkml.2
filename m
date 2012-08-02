Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923Ab2HBNSQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 09:18:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21562 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753594Ab2HBNSP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 09:18:15 -0400
Date: Thu, 2 Aug 2012 10:15:27 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 4/9] KVM: define kvm_bad_pfn statically
Message-ID: <20120802131527.GE25344@amt.cnet>
References: <5014F053.8020305@linux.vnet.ibm.com>
 <5014F0E1.4010909@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5014F0E1.4010909@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 29, 2012 at 04:14:25PM +0800, Xiao Guangrong wrote:
> Then, remove get_bad_pfn
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  include/linux/kvm_host.h |    1 +
>  virt/kvm/kvm_main.c      |    7 +------
>  2 files changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 4de56cd..b02203f 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -50,6 +50,7 @@
> 
>  #define kvm_fault_pfn		(-EFAULT)
>  #define kvm_hwpoison_pfn	(-EHWPOISON)
> +#define kvm_bad_pfn		(-ENOENT)

Remind me what is the guarantee that -Exxx does not clash with
a valid pfn number?


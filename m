Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933587Ab2C2Pt3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 11:49:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50521 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932719Ab2C2PtW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 11:49:22 -0400
Message-ID: <4F74847A.1030809@redhat.com>
Date: Thu, 29 Mar 2012 17:49:14 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120316 Thunderbird/11.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 08/13] KVM: MMU: fask check whether page is writable
References: <4F742951.7080003@linux.vnet.ibm.com> <4F742A74.1050304@linux.vnet.ibm.com>
In-Reply-To: <4F742A74.1050304@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2012 11:25 AM, Xiao Guangrong wrote:
> Using PTE_LIST_WRITE_PROTECT bit in rmap store the write-protect status to
> avoid unnecessary shadow page walking

Does kvm_set_pte_rmapp() need adjustment?

> Also if no shadow page is indirect, the page is write-free
>
>
> +	if (!vcpu->kvm->arch.indirect_shadow_pages)
> +		return 0;
> +
Best in its own little patch.


-- 
error compiling committee.c: too many arguments to function


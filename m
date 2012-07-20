Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948Ab2GTAtg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 20:49:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38625 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752649Ab2GTAsb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 20:48:31 -0400
Date: Thu, 19 Jul 2012 21:39:17 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 5/9] KVM: MMU: fask check write-protect for direct mmu
Message-ID: <20120720003917.GA8951@amt.cnet>
References: <50056DB8.7080702@linux.vnet.ibm.com>
 <50056E59.4090003@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50056E59.4090003@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2012 at 09:53:29PM +0800, Xiao Guangrong wrote:
> If it have no indirect shadow pages we need not protect any gfn,
> this is always true for direct mmu without nested
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>

Xiao,

What is the motivation? Numbers please.

In fact, what case was the original indirect_shadow_pages conditional in
kvm_mmu_pte_write optimizing again?



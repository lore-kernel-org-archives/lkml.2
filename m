Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757218Ab1ETVb7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 17:31:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11107 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756743Ab1ETVbv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 17:31:51 -0400
Date: Fri, 20 May 2011 12:49:32 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 1/7] KVM: MMU: optimize pte write path if don't have
 protected sp
Message-ID: <20110520154931.GA3627@amt.cnet>
References: <4DCFEF3B.5060806@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DCFEF3B.5060806@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 15, 2011 at 11:20:27PM +0800, Xiao Guangrong wrote:
> Simply return from kvm_mmu_pte_write path if no shadow page is
> write-protected, then we can avoid to walk all shadow pages and hold
> mmu-lock
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>

Applied, thanks.


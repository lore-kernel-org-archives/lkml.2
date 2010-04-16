Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757874Ab0DPVEE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 17:04:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28852 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756076Ab0DPVEB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 17:04:01 -0400
Date: Fri, 16 Apr 2010 18:03:44 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/2] KVM MMU: fix kvm_mmu_zap_page() and its calling
 path
Message-ID: <20100416210344.GB22144@amt.cnet>
References: <4BC82122.4020805@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BC82122.4020805@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 16, 2010 at 04:34:42PM +0800, Xiao Guangrong wrote:
> This patch fix:
> 
> - calculate zapped page number properly in mmu_zap_unsync_children()
> - calculate freeed page number properly kvm_mmu_change_mmu_pages()
> - if zapped children page it shoud restart hlist walking
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>

Applied both, thanks.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710Ab2DSCsG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 22:48:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21189 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753529Ab2DSCsB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 22:48:01 -0400
Date: Wed, 18 Apr 2012 23:35:58 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Davidlohr Bueso <dave@gnu.org>
Cc: Avi Kivity <avi@redhat.com>, KVM <kvm@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: MMU: use page table level macro
Message-ID: <20120419023558.GC17648@amt.cnet>
References: <1334744669.2601.1.camel@offbook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334744669.2601.1.camel@offbook>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 12:24:29PM +0200, Davidlohr Bueso wrote:
> From: Davidlohr Bueso <dave@gnu.org>
> 
> Its much cleaner to use PT_PAGE_TABLE_LEVEL than its numeric value.
> 
> Signed-off-by: Davidlohr Bueso <dave@gnu.org>
> ---
>  arch/x86/kvm/mmu.c         |    2 +-
>  arch/x86/kvm/paging_tmpl.h |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

Applied, thanks.


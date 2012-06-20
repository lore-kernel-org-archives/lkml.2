Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010Ab2FTNuO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 09:50:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57811 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291Ab2FTNuM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 09:50:12 -0400
Date: Wed, 20 Jun 2012 15:47:51 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] uprobes: __replace_page() should not use
	page_address_in_vma()
Message-ID: <20120620134750.GA11582@redhat.com>
References: <20120619194636.GA30137@redhat.com> <20120619194712.GB30146@redhat.com> <20120620120742.GK4629@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120620120742.GK4629@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20, Srikar Dronamraju wrote:
>
> > -static int __replace_page(struct vm_area_struct *vma, struct page *page, struct page *kpage)
> > +static int __replace_page(struct vm_area_struct *vma, unsigned long addr,
> > +				struct page *page, struct page *kpage)
>
> Could please update the comment above __replace_page to mention that it
> now takes addr as a parameter?

Will do, thanks.

Oleg.


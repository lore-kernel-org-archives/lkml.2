Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686Ab2GCPRW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 11:17:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48148 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751278Ab2GCPRU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 11:17:20 -0400
Date: Tue, 3 Jul 2012 12:11:28 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v7 00/10] KVM: MMU: fast page fault
Message-ID: <20120703151128.GA17302@amt.cnet>
References: <4FE1822D.8010002@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FE1822D.8010002@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2012 at 03:56:29PM +0800, Xiao Guangrong wrote:
> Changlog:
> - always atomicly update the spte if it can be updated out of mmu-lock
> - rename spte_can_be_writable() to spte_is_locklessly_modifiable()
> - cleanup and comment spte_write_protect()
> 
> Performance result:
> (The benchmark can be found at: http://www.spinics.net/lists/kvm/msg73011.html)
> 
>                                before            after
> Run 10 times, Avg time:      538233957 ns.      249809853 ns. +53.6%

Looks fine to me. 


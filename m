Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945965Ab2LOBYQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 20:24:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63757 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945926Ab2LOBYO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 20:24:14 -0500
Date: Fri, 14 Dec 2012 23:05:46 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Gleb Natapov <gleb@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 0/5] KVM: x86: improve reexecute_instruction
Message-ID: <20121215010546.GC27536@amt.cnet>
References: <50C5A747.1020105@linux.vnet.ibm.com>
 <20121211233641.GA14520@amt.cnet>
 <50C8E3A3.4050106@linux.vnet.ibm.com>
 <20121213225408.GB11385@amt.cnet>
 <50CAB001.2040106@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50CAB001.2040106@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2012 at 12:50:09PM +0800, Xiao Guangrong wrote:
> >>> program a timer interrupt and #GP? 
> >>
> >> Could you please explain the detail?
> > 
> > Before the instruction which writes continuously to the pagetable, arm
> > say lapic timer. #GP on the interrupt handler and test with failure.
> 
> Sorry, I am confused about this. After Qemu exits due to KVM_EXIT_INTERNAL_ERROR,
> the vm is stopped then interrupt can not be injected to guest. Or i missed something?

Yes, but without fixed kernel kvm-unit test executable loops continuously.
Perhaps its more appropriate to fix generically, nevermind.


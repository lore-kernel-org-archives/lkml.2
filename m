Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886Ab2GTMCT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 08:02:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57715 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752322Ab2GTMCJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 08:02:09 -0400
Date: Fri, 20 Jul 2012 08:45:01 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 5/9] KVM: MMU: fask check write-protect for direct mmu
Message-ID: <20120720114501.GB23285@amt.cnet>
References: <50056DB8.7080702@linux.vnet.ibm.com>
 <50056E59.4090003@linux.vnet.ibm.com>
 <20120720003917.GA8951@amt.cnet>
 <5008D477.2020007@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5008D477.2020007@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2012 at 11:45:59AM +0800, Xiao Guangrong wrote:
> BTW, they are some bug fix patches on -master branch, but
> it is not existed on -next branch:
> commit: f411930442e01f9cf1bf4df41ff7e89476575c4d
> commit: 85b7059169e128c57a3a8a3e588fb89cb2031da1
> 
> It causes code conflict if we do the development on -next.

See auto-next branch.

http://www.linux-kvm.org/page/Kvm-Git-Workflow



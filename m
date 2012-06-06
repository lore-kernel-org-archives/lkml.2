Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487Ab2FFJkV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 05:40:21 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:65486 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403Ab2FFJkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 05:40:20 -0400
Date: Wed, 6 Jun 2012 11:40:15 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linuxppc-dev@lists.ozlabs.org,
        lkml <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        benh@kernel.crashing.org,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Anton Blanchard <anton@samba.org>, Ingo Molnar <mingo@elte.hu>,
        oleg@redhat.com
Subject: Re: [PATCH 1/2] uprobes: Pass probed vaddr to
 arch_uprobe_analyze_insn()
Message-ID: <20120606094014.GD9495@gmail.com>
References: <20120606091950.GB6745@in.ibm.com>
 <1338974632.2749.87.camel@twins>
 <20120606093744.GB29580@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120606093744.GB29580@in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ananth N Mavinakayanahalli <ananth@in.ibm.com> wrote:

> On Wed, Jun 06, 2012 at 11:23:52AM +0200, Peter Zijlstra wrote:
> > On Wed, 2012-06-06 at 14:49 +0530, Ananth N Mavinakayanahalli wrote:
> > > +int arch_uprobe_analyze_insn(struct arch_uprobe *auprobe, struct mm_struct *mm, loff_t vaddr)
> > 
> > Don't we traditionally use unsigned long to pass vaddrs?
> 
> Right. But the vaddr we pass here is vma_info->vaddr which is loff_t.
> I guess I should've made that clear in the patch description.

Why not fix struct vma_info's vaddr type?

Thanks,

	Ingo

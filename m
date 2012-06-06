Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363Ab2FFJYO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 05:24:14 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42892 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab2FFJYN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 05:24:13 -0400
Message-ID: <1338974632.2749.87.camel@twins>
Subject: Re: [PATCH 1/2] uprobes: Pass probed vaddr to
 arch_uprobe_analyze_insn()
From: Peter Zijlstra <peterz@infradead.org>
To: ananth@in.ibm.com
Cc: linuxppc-dev@lists.ozlabs.org, lkml <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>, benh@kernel.crashing.org,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Anton Blanchard <anton@samba.org>, Ingo Molnar <mingo@elte.hu>,
        oleg@redhat.com
Date: Wed, 06 Jun 2012 11:23:52 +0200
In-Reply-To: <20120606091950.GB6745@in.ibm.com>
References: <20120606091950.GB6745@in.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-06 at 14:49 +0530, Ananth N Mavinakayanahalli wrote:
> +int arch_uprobe_analyze_insn(struct arch_uprobe *auprobe, struct mm_struct *mm, loff_t vaddr)

Don't we traditionally use unsigned long to pass vaddrs?

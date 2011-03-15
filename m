Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756499Ab1COT5D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 15:57:03 -0400
Received: from mout.perfora.net ([74.208.4.194]:51462 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755263Ab1COT45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 15:56:57 -0400
Date: Tue, 15 Mar 2011 15:56:36 -0400
From: Stephen Wilson <wilsons@start.ca>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christoph Hellwig <hch@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andi Kleen <andi@firstfloor.org>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        SystemTap <systemtap@sources.redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 2.6.38-rc8-tip 16/20] 16: uprobes: register a
	notifier for uprobes.
Message-ID: <20110315195636.GB24972@fibrous.localdomain>
References: <20110314133403.27435.7901.sendpatchset@localhost6.localdomain6> <20110314133708.27435.81257.sendpatchset@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110314133708.27435.81257.sendpatchset@localhost6.localdomain6>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Provags-ID: V02:K0:5buwGYTx2W+eubxkUejqChUNSQKhcwXGIYdDlZoSAax
 ehBkpy+3aF/7+EFvmMM46Tzx0Yhlyr8EueYPTdSNdN9pBWqxOb
 qu2IAk6JooMVp+1gV/qFJinWtK7zWb60JGqciHREnfdXQCS480
 nYSBjrE0KdSEhYuqkrj/PHJLWvYbFq0HJ7qnrDfXAgkMPHElli
 Dd4dijdC6BZ43nPXGsseueN9L7ClWS20wi1iDSz25Q=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 14, 2011 at 07:07:08PM +0530, Srikar Dronamraju wrote:
> +static int __init init_uprobes(void)
> +{
> +	register_die_notifier(&uprobes_exception_nb);
> +	return 0;
> +}
> +

Although not currently needed, perhaps it would be best to return the
result of register_die_notifier() ? 

-- 
steve


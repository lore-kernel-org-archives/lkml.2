Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183Ab1CNP3O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 11:29:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:47792 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966Ab1CNP3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 11:29:10 -0400
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=NhuigFM5MhYA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=gHhx2tW0LaDl3lk1CoEA:9 a=2qVoUX2Bhxc_E71021c06H6PzCUA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH v2 2.6.38-rc8-tip 3/20]  3: uprobes: Breakground page
 replacement.
From: Steven Rostedt <rostedt@goodmis.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andi Kleen <andi@firstfloor.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        SystemTap <systemtap@sources.redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <20110314133433.27435.49566.sendpatchset@localhost6.localdomain6>
References: <20110314133403.27435.7901.sendpatchset@localhost6.localdomain6>
	 <20110314133433.27435.49566.sendpatchset@localhost6.localdomain6>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 14 Mar 2011 11:29:06 -0400
Message-ID: <1300116546.9910.107.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-03-14 at 19:04 +0530, Srikar Dronamraju wrote:
> +/*
> + * Most architectures can use the default versions of @read_opcode(),
> + * @set_bkpt(), @set_orig_insn(), and @is_bkpt_insn();
> + *
> + * @set_ip:
> + *     Set the instruction pointer in @regs to @vaddr.
> + * @analyze_insn:
> + *     Analyze @user_bkpt->insn.  Return 0 if @user_bkpt->insn is an
> + *     instruction you can probe, or a negative errno (typically -%EPERM)
> + *     otherwise. Determine what sort of

sort of ... what?

-- Steve

> + * @pre_xol:
> + * @post_xol:
> + *     XOL-related fixups @post_xol() (and possibly @pre_xol()) will need
> + *     to do for this instruction, and annotate @user_bkpt accordingly.
> + *     You may modify @user_bkpt->insn (e.g., the x86_64 port does this
> + *     for rip-relative instructions).
> + */ 


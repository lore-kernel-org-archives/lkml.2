Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949Ab1FISiy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 14:38:54 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36770 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683Ab1FISix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 14:38:53 -0400
Subject: Re: [PATCH v4 3.0-rc2-tip 0/22]  0: Uprobes patchset with perf
 probe support
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hugh Dickins <hughd@google.com>, Christoph Hellwig <hch@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20110607125804.28590.92092.sendpatchset@localhost6.localdomain6>
References: <20110607125804.28590.92092.sendpatchset@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Jun 2011 20:42:24 +0200
Message-ID: <1307644944.2497.1023.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-07 at 18:28 +0530, Srikar Dronamraju wrote:
> - Breakpoint handling should co-exist with singlestep/blockstep from
>   another tracer/debugger.
> - Queue and dequeue signals delivered from the singlestep till
>   completion of postprocessing. 

These two are important to sort before we can think of merging this
right?


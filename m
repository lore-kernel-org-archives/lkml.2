Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409Ab1KXKBG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 05:01:06 -0500
Received: from casper.infradead.org ([85.118.1.10]:39494 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754941Ab1KXKBF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 05:01:05 -0500
Message-ID: <1322128832.2921.4.camel@twins>
Subject: Re: Fwd: uprobes: register/unregister probes.
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Roland McGrath <roland@hack.frob.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Anton Arapov <anton@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>, tulasidhard@gmail.com
Date: Thu, 24 Nov 2011 11:00:32 +0100
In-Reply-To: <20111124094956.GC28065@linux.vnet.ibm.com>
References: <hYuXv-26J-3@gated-at.bofh.it> <hYuXw-26J-5@gated-at.bofh.it>
	 <i0nRU-7eK-11@gated-at.bofh.it>
	 <603b0079-5f54-4299-9a9a-a5e237ccca73@l23g2000pro.googlegroups.com>
	 <20111124094956.GC28065@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-24 at 15:19 +0530, Srikar Dronamraju wrote:
>                           Subject: 
> Re: Fwd: uprobes:
> register/unregister probes.
> 
Why is this a fwd and breaking threading?

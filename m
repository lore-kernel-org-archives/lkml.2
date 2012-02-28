Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755641Ab2B1O1x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 09:27:53 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58968 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755480Ab2B1O1w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 09:27:52 -0500
Date: Tue, 28 Feb 2012 15:27:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Anton Arapov <anton@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Jiri Olsa <jolsa@redhat.com>, Josh Stone <jistone@redhat.com>
Subject: Re: [PATCH] uprobes/core: handle breakpoint and signal step
 exception.
Message-ID: <20120228142731.GB15700@elte.hu>
References: <20120223110245.12459.7391.sendpatchset@srdronam.in.ibm.com>
 <20120227091212.GA7092@elte.hu>
 <20120228132601.GC32211@linux.vnet.ibm.com>
 <20120228135251.GA8279@elte.hu>
 <20120228141743.GA32472@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120228141743.GA32472@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Srikar Dronamraju <srikar@linux.vnet.ibm.com> wrote:

> > > The current unregistering thread waits till all other 
> > > threads that have hit a breakpoint to acquire the 
> > > uprobes_treelock before the uprobe is removed from the 
> > > rbtree.
> > 
> > s/is removed/are removed
> > 
> > ?
> > 
> 
> At a time, we are unregistering just one probe,(atleast for 
> now.) Wondering if "before uprobes are remove from rbtree." 
> sounds as if more than one uprobe is being removed at one 
> instance.

The sentence still does not parse:

  " X waits until Ys that have done Z before A is removed from
    the rbtree"

Did you want to say:

" The current unregistering thread waits till all other
  threads have hit a breakpoint, to acquire the
  uprobes_treelock before the uprobe is removed from the
  rbtree. "

(I have removed 'that' and added a comma.)

Thanks,

	Ingo

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642Ab1JOTFP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 15:05:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31166 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754448Ab1JOTFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 15:05:12 -0400
Date: Sat, 15 Oct 2011 21:00:07 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hugh Dickins <hughd@google.com>, Christoph Hellwig <hch@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/X] (Was:  Uprobes patchset with perf probe support)
Message-ID: <20111015190007.GA30243@redhat.com>
References: <20110920115938.25326.93059.sendpatchset@srdronam.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110920115938.25326.93059.sendpatchset@srdronam.in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I was trying to make the signal patches we discussed, but I have
noticed other problems.

Please see the suggested initial fixes, more to come. Of course
there were not tested ;) Please review.

And. It it not that I suggest to add this series, just it is much
simpler to me to write the patch with the changelog to explain
what I mean.

IOW, if you agree with these fixes, please incorporate them into
the next version. Feel free to redo.

Oleg.


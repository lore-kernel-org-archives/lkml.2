Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763Ab1JSV5D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 17:57:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45112 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751012Ab1JSV5B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 17:57:01 -0400
Date: Wed, 19 Oct 2011 23:51:39 +0200
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
Subject: [PATCH 8-14/X] (Was:  Uprobes patchset with perf probe support)
Message-ID: <20111019215139.GA16395@redhat.com>
References: <20110920115938.25326.93059.sendpatchset@srdronam.in.ibm.com> <20111015190007.GA30243@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111015190007.GA30243@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Signal patches for uprobes. Note that there are more issues than
we discussed before, we can not simply delay/block/whatever the
signal.

This needs a bit more cleanups (and perhaps minor fixes), but I
_think_ this should work. Well, I hope ;)

On top of 1-7 I sent before.

Oleg.


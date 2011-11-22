Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751189Ab1KVFE1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 00:04:27 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:59205 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750766Ab1KVFEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 00:04:25 -0500
Date: Tue, 22 Nov 2011 10:33:30 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Roland McGrath <roland@hack.frob.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v7 3.2-rc2 0/30] uprobes patchset with perf probe
 support
Message-ID: <20111122050330.GA24807@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20111118110631.10512.73274.sendpatchset@srdronam.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20111118110631.10512.73274.sendpatchset@srdronam.in.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11112205-8974-0000-0000-00000290A482
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo, Thomas, Linus, Stephen, Peter,

> This patchset resolves most of the comments on the previous posting
> (https://lkml.org/lkml/2011/11/10/408) patchset applies on top of
> commit cfcfc9eca2b
> 
> This patchset depends on bulkref patch from Paul McKenney
> https://lkml.org/lkml/2011/11/2/365 and enable interrupts before
> calling do_notify_resume on i686 patch
> https://lkml.org/lkml/2011/10/25/265.
> 
> uprobes git is hosted at git://github.com/srikard/linux.git
> with branch inode_uprobes_v32rc2.
> (The previous patchset posted to lkml has been rebased to 3.2-rc2 is also
> available at branch inode_uprobes_v32rc2_prev. This is to help the
> reviewers of the previous patchsets to quickly identify the changes.)
> 
> Uprobes Patches
> This patchset implements inode based uprobes which are specified as
> <file>:<offset> where offset is the offset from start of the map.

Given that uprobes has been reviewed several times on LKML and all
comments till now have been addressed, can we push uprobes into either
-tip or -next. This will help people to test and give more feedback and
also provide a way for it to be pushed into 3.3. This also helps in
resolving and pushing fixes faster.

If you have concerns, can you please voice them?

-- 
Thanks and Regards
Srikar


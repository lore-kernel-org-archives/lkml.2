Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030511Ab2HPVlR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 17:41:17 -0400
Received: from mail.x86-64.org ([217.9.48.20]:53347 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933430Ab2HPVlN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 17:41:13 -0400
Date: Thu, 16 Aug 2012 23:41:03 +0200
From: Borislav Petkov <bp@amd64.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH -v2 0/4] Persistent events
Message-ID: <20120816214103.GE16308@aftab.osrc.amd.com>
References: <1345139123-15212-1-git-send-email-bp@amd64.org>
 <20120816141253.0142ddd0@lwn.net>
 <20120816205539.GA16308@aftab.osrc.amd.com>
 <1345151613.3708.4.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345151613.3708.4.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2012 at 05:13:33PM -0400, Steven Rostedt wrote:
> BTW, we already have a persistent buffering in the kernel. It's used
> by ftrace. What about having perf use that buffering for persistent
> events? Or is there some other issues about using it.

Not that I know of.

I coded this with the perf ring buffer now. If only there was one ring
buffer in the kernel.. /me ducks and hides.

Ok, with perf I can read out the events programmatically by mmaping the
per-CPU buffer with perf_mmap. How do you do that in ftrace? Any code
pointers I can stare at?

> I'm currently working on having perf read ftrace data, so in the near
> future, I plan on having some RFC patches to have perf reading from
> this buffer anyway.

Are you saying the ftrace buffer would be mmappable too now?

Btw, I wanted to hear your opinion on patch 1/4 since it touches
ftrace/trace_events code. Can you please look at it and tell me if its
ok?

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551

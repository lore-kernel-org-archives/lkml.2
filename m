Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761362Ab2EQIHI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 04:07:08 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:64877 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761339Ab2EQIG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 04:06:58 -0400
Date: Thu, 17 May 2012 10:06:52 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH] tracing: Remove useless 4 bytes of padding from
 every event
Message-ID: <20120517080651.GC17419@gmail.com>
References: <1337175871.6724.46.camel@gandalf.stny.rr.com>
 <CA+55aFzVngkixn-t0mK8QqgnPhCzN2AsUtzfZ3BkLiJAcjNOzQ@mail.gmail.com>
 <1337198404.6724.81.camel@gandalf.stny.rr.com>
 <CA+55aFyKiNBRv=z8JjPTu=yFFvyWHhkGDxjWLm=R4HpwXzEw4g@mail.gmail.com>
 <4FB408F2.8060002@linux.intel.com>
 <20120516201431.GA29661@redhat.com>
 <4FB40B2B.703@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FB40B2B.703@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arjan van de Ven <arjan@linux.intel.com> wrote:

> > One possibility would be a config symbol to enable the 
> > deprecated field (kind of like what we did with compat 
> > vdso).  Distros that have a new enough powertop can then 
> > disable it.
> 
> this isn't really about distro kernels; a distro that pushes a 
> 3.7 kernel to Fedora 15 might as well do a powertop upgrade.. 
> the later is much simpler and lighter (the main difference 
> between 1.98 and 2.0 is the use of the perfevent library 
> anyway)
> 
> it's about people who compile their own upstream kernel...

Nor should we waste too much time over these 4 bytes really. Is 
the kernel really in such a good shape that we must spend our 
time trying to break working apps, over a mostly cosmetic detail 
in an ABI which will soon be messed up with our next set up 
mistakes anyway? ;-)

Thanks,

	Ingo

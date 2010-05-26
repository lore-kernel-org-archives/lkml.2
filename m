Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902Ab0EZQAg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 12:00:36 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64999 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756583Ab0EZQAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 12:00:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Yc0xv/q86dFx08jx1O82Po0Wo8F22tw6ktvOpuLcXCJFZn7OhVvTNbLjJvsblsmEwi
         7HYRWW4cftOsX2MfXX29UWjVupGf4bHEPzVcMQ1vNeTwj5w4Ddfapuzf0RVxXORt369I
         ELDvht+Wqw7KID6lCGPrLYho1Hzutg6EG4E/A=
Date: Wed, 26 May 2010 18:00:30 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH] tracing: Remove kmemtrace ftrace plugin
Message-ID: <20100526160028.GC5299@nowhere>
References: <4BFCE849.7090804@cn.fujitsu.com> <20100526095934.GA5311@nowhere> <1274880514.27810.454.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274880514.27810.454.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26, 2010 at 03:28:34PM +0200, Peter Zijlstra wrote:
> On Wed, 2010-05-26 at 11:59 +0200, Frederic Weisbecker wrote:
> > On Wed, May 26, 2010 at 05:22:17PM +0800, Li Zefan wrote:
> > > We have been resisting new ftrace plugins and removing existing
> > > ones, and kmemtrace has been superseded by kmem trace events
> > > and perf-kmem, so we remove it.
> > > 
> > > Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> > > Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
> > > ---
> > >  Documentation/ABI/testing/debugfs-kmemtrace |   71 ----
> > >  Documentation/trace/kmemtrace.txt           |  126 -------
> > >  MAINTAINERS                                 |    7 -
> > >  include/linux/kmemtrace.h                   |   25 --
> > >  include/linux/slab_def.h                    |    3 +-
> > >  include/linux/slub_def.h                    |    3 +-
> > >  init/main.c                                 |    2 -
> > >  kernel/trace/Kconfig                        |   20 -
> > >  kernel/trace/kmemtrace.c                    |  529 ---------------------------
> > >  kernel/trace/trace.h                        |   13 -
> > >  kernel/trace/trace_entries.h                |   35 --
> > >  mm/slab.c                                   |    1 -
> > >  mm/slub.c                                   |    1 -
> > >  13 files changed, 4 insertions(+), 832 deletions(-)
> > >  delete mode 100644 Documentation/ABI/testing/debugfs-kmemtrace
> > >  delete mode 100644 Documentation/trace/kmemtrace.txt
> > >  delete mode 100644 include/linux/kmemtrace.h
> > >  delete mode 100644 kernel/trace/kmemtrace.c
> > 
> > 
> > 
> > Thanks!
> > 
> > Just one thing: you forgot to update the kernel/trace/Makefile
> 
> You can also axe kernel/tracing/trace_sysprof.c and related bits.


I'll do that too, but I 'll need Soeren's opinion before actually pushing it.

Thanks.


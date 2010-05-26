Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529Ab0EZN3B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 09:29:01 -0400
Received: from casper.infradead.org ([85.118.1.10]:38866 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189Ab0EZN3A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 09:29:00 -0400
Subject: Re: [PATCH] tracing: Remove kmemtrace ftrace plugin
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
In-Reply-To: <20100526095934.GA5311@nowhere>
References: <4BFCE849.7090804@cn.fujitsu.com>
	 <20100526095934.GA5311@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 26 May 2010 15:28:34 +0200
Message-ID: <1274880514.27810.454.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-26 at 11:59 +0200, Frederic Weisbecker wrote:
> On Wed, May 26, 2010 at 05:22:17PM +0800, Li Zefan wrote:
> > We have been resisting new ftrace plugins and removing existing
> > ones, and kmemtrace has been superseded by kmem trace events
> > and perf-kmem, so we remove it.
> > 
> > Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> > Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
> > ---
> >  Documentation/ABI/testing/debugfs-kmemtrace |   71 ----
> >  Documentation/trace/kmemtrace.txt           |  126 -------
> >  MAINTAINERS                                 |    7 -
> >  include/linux/kmemtrace.h                   |   25 --
> >  include/linux/slab_def.h                    |    3 +-
> >  include/linux/slub_def.h                    |    3 +-
> >  init/main.c                                 |    2 -
> >  kernel/trace/Kconfig                        |   20 -
> >  kernel/trace/kmemtrace.c                    |  529 ---------------------------
> >  kernel/trace/trace.h                        |   13 -
> >  kernel/trace/trace_entries.h                |   35 --
> >  mm/slab.c                                   |    1 -
> >  mm/slub.c                                   |    1 -
> >  13 files changed, 4 insertions(+), 832 deletions(-)
> >  delete mode 100644 Documentation/ABI/testing/debugfs-kmemtrace
> >  delete mode 100644 Documentation/trace/kmemtrace.txt
> >  delete mode 100644 include/linux/kmemtrace.h
> >  delete mode 100644 kernel/trace/kmemtrace.c
> 
> 
> 
> Thanks!
> 
> Just one thing: you forgot to update the kernel/trace/Makefile

You can also axe kernel/tracing/trace_sysprof.c and related bits.

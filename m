Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934190Ab0EZJ7o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 05:59:44 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33959 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231Ab0EZJ7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 05:59:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=B2wm4RyhiYcc9HzIICT5tmxKhElWyeR6Lq85iz3FI5NIonDwN0SHZxcC6giUCocCYK
         jQYARsCrGZrJjlsptb0UIGiTQIN3BFXRrLSK9L7cz2hr2wIWMtmk4OeSg/6WZdNZHS4f
         QQSiiVkvwgKstYiZcuF5pdZwo85FVcE2Mjx0A=
Date: Wed, 26 May 2010 11:59:40 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH] tracing: Remove kmemtrace ftrace plugin
Message-ID: <20100526095934.GA5311@nowhere>
References: <4BFCE849.7090804@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BFCE849.7090804@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26, 2010 at 05:22:17PM +0800, Li Zefan wrote:
> We have been resisting new ftrace plugins and removing existing
> ones, and kmemtrace has been superseded by kmem trace events
> and perf-kmem, so we remove it.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
> ---
>  Documentation/ABI/testing/debugfs-kmemtrace |   71 ----
>  Documentation/trace/kmemtrace.txt           |  126 -------
>  MAINTAINERS                                 |    7 -
>  include/linux/kmemtrace.h                   |   25 --
>  include/linux/slab_def.h                    |    3 +-
>  include/linux/slub_def.h                    |    3 +-
>  init/main.c                                 |    2 -
>  kernel/trace/Kconfig                        |   20 -
>  kernel/trace/kmemtrace.c                    |  529 ---------------------------
>  kernel/trace/trace.h                        |   13 -
>  kernel/trace/trace_entries.h                |   35 --
>  mm/slab.c                                   |    1 -
>  mm/slub.c                                   |    1 -
>  13 files changed, 4 insertions(+), 832 deletions(-)
>  delete mode 100644 Documentation/ABI/testing/debugfs-kmemtrace
>  delete mode 100644 Documentation/trace/kmemtrace.txt
>  delete mode 100644 include/linux/kmemtrace.h
>  delete mode 100644 kernel/trace/kmemtrace.c



Thanks!

Just one thing: you forgot to update the kernel/trace/Makefile


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391Ab2DIRKw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 13:10:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56572 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226Ab2DIRKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 13:10:48 -0400
MIME-Version: 1.0
In-Reply-To: <20120406155109.GA2693@x1.osrc.amd.com>
References: <1333666086-6517-1-git-send-email-fweisbec@gmail.com>
	<1333666086-6517-4-git-send-email-fweisbec@gmail.com>
	<20120406114502.GD30425@liondog.tnic>
	<CAFTL4hzvy1wgm8e7_h2S6Fa_A+QybUsssetLaWyUu3tB5a2m1w@mail.gmail.com>
	<20120406155109.GA2693@x1.osrc.amd.com>
Date: Mon, 9 Apr 2012 19:10:47 +0200
Message-ID: <CAFTL4hxo3aQT32RZT64wjARYiGLTkvAvKUuoQZw81mTDXdS8nA@mail.gmail.com>
Subject: Re: [PATCH 03/15] perf: Build libtraceevent.a
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Borislav Petkov <bp@alien8.de>, Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <srostedt@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Arun Sharma <asharma@fb.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/4/6 Borislav Petkov <bp@alien8.de>:
> Right, what I meant was to add the $(LIBTRACEEVENT): target above to the
> toplevel Makefile so that when you're in the kernel source tree, you do
>
> $ make tools/perf
>
> it has a target $(LIBTRACEEVENT) dependent on it in the toplevel
> Makefile instead of perf's Makefile to avoid duplication. Then, when
> perf is rebuilt, it simply links with this lib. IOW, not have the "make
> -C" call in perf's Makefile but in the toplevel Makefile because other
> tools will want to use libtraceevent.a too and link against it.
>
> Oh well, the toplevel Makefile patches aren't upstream either so we're
> wasting cycles here, I'll fix that up when the times comes.

Yeah let's sort those details out once we have that library merged ;)

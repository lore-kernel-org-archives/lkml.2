Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199Ab2ISNap (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 09:30:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37040 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515Ab2ISNan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 09:30:43 -0400
Subject: Re: [PATCH] tools lib traceevent: Handle alloc_arg failure
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung.kim@lge.com>
In-Reply-To: <1348058460.13080.52.camel@gandalf.local.home>
References: <87boh23epi.fsf@sejong.aot.lge.com>
	 <1348037109-17252-1-git-send-email-namhyung@kernel.org>
	 <20120919114258.GA16696@gmail.com> <1348057609.1644.9.camel@leonhard>
	 <1348058460.13080.52.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 19 Sep 2012 22:30:35 +0900
Message-ID: <1348061435.1470.4.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,

2012-09-19 (수), 08:41 -0400, Steven Rostedt:
> On Wed, 2012-09-19 at 21:26 +0900, Namhyung Kim wrote:
> > Yeah, I agree.  But I wanted to add a bit more helpful (to developers)
> > info - function name and line number - rather than just "not enough
> > memory" message.  Maybe we could change do_warning to emit such info
> > automatically.
> 
> But these only fail if you run out of memory for the tool. In that case,
> I don't think it's that important which allocation failed.

Okay, I'll send v2 tomorrow according to Ingo's suggestion.

Thanks,
Namhyung



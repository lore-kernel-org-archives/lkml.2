Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756459Ab2DYQim (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 12:38:42 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46451 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073Ab2DYQil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 12:38:41 -0400
Date: Wed, 25 Apr 2012 13:37:38 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>,
        Namhyung Kim <namhyung.kim@lge.com>, Jiri Olsa <jolsa@redhat.com>,
        Arun Sharma <asharma@fb.com>, Michael Rubin <mrubin@google.com>,
        David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Julia Lawall <julia@diku.dk>, Tom Zanussi <tzanussi@gmail.com>
Subject: Re: Our failure on tracing tools unification
Message-ID: <20120425163738.GE17992@infradead.org>
References: <1333666086-6517-1-git-send-email-fweisbec@gmail.com>
 <20120423144743.GB29985@somewhere>
 <1335193719.28150.171.camel@twins>
 <20120425080525.GA32613@gmail.com>
 <y0m8vhjopvs.fsf@fche.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <y0m8vhjopvs.fsf@fche.csb>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Apr 25, 2012 at 10:19:35AM -0400, Frank Ch. Eigler escreveu:
> 
> mingo wrote:
> 
> > [...]  One thing that would suck is perf being bound by various
> > versions of this library floating out there.
> 
> Could the event parser shared library be ABI-preserving?  If so, what
> would perf have to fear?

Perhaps its because people working on perf grew in the kernel, where we
can change things as we see fit, i.e. change the networking API? Sure,
we can go over the drivers and change them, its all in the same source
tree, etc.

> > [...] We had nothing but pain from external libraries so far [...]
> 
> If the elfutils, newt, gtk, bfd, iberty, zlib, python libraries didn't
> contribute useful and un-rewriteable functionality, perf would not be
> using them.

newt was a pain and will go away, 99% of things rely just on libslang,
but even that one could go, bfd we use just for C++ demangling, so
probably could go too.

- Arnaldo

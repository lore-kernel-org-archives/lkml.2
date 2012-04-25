Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322Ab2DYOUa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 10:20:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59400 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752073Ab2DYOU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 10:20:29 -0400
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>,
        Namhyung Kim <namhyung.kim@lge.com>, Jiri Olsa <jolsa@redhat.com>,
        Arun Sharma <asharma@fb.com>, Michael Rubin <mrubin@google.com>,
        David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Julia Lawall <julia@diku.dk>, Tom Zanussi <tzanussi@gmail.com>
Subject: Re: Our failure on tracing tools unification
References: <1333666086-6517-1-git-send-email-fweisbec@gmail.com>
	<20120423144743.GB29985@somewhere> <1335193719.28150.171.camel@twins>
	<20120425080525.GA32613@gmail.com>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Wed, 25 Apr 2012 10:19:35 -0400
In-Reply-To: <20120425080525.GA32613@gmail.com> (Ingo Molnar's message of "Wed, 25 Apr 2012 10:05:25 +0200")
Message-ID: <y0m8vhjopvs.fsf@fche.csb>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


mingo wrote:

> [...]  One thing that would suck is perf being bound by various
> versions of this library floating out there.

Could the event parser shared library be ABI-preserving?  If so, what
would perf have to fear?

> [...] We had nothing but pain from external libraries so far [...]

If the elfutils, newt, gtk, bfd, iberty, zlib, python libraries didn't
contribute useful and un-rewriteable functionality, perf would not be
using them.


- FChE

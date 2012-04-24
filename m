Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932135Ab2DXJKW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 05:10:22 -0400
Received: from www.linutronix.de ([62.245.132.108]:60666 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756479Ab2DXJKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 05:10:20 -0400
Date: Tue, 24 Apr 2012 11:10:12 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, Namhyung Kim <namhyung.kim@lge.com>,
        Jiri Olsa <jolsa@redhat.com>, Arun Sharma <asharma@fb.com>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Julia Lawall <julia@diku.dk>, Tom Zanussi <tzanussi@gmail.com>
Subject: Re: Our failure on tracing tools unification (Was: Re: [RFC][PATCH
 00/15] tools: Unify perf and trace-cmd trace event format parsing v2)
In-Reply-To: <1335193719.28150.171.camel@twins>
Message-ID: <alpine.LFD.2.02.1204241014471.2542@ionos>
References: <1333666086-6517-1-git-send-email-fweisbec@gmail.com>  <20120423144743.GB29985@somewhere> <1335193719.28150.171.camel@twins>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Apr 2012, Peter Zijlstra wrote:

> On Mon, 2012-04-23 at 16:47 +0200, Frederic Weisbecker wrote:
> > Ingo doesn't seem to want this library outside perf in order to avoid
> > the fragmentation of the efforts on tracing tools.
> 
> I really don't see the point.. parsing /debug/tracing/events/*/format
> gunk really is separate, furthermore things like powertop et al already
> are separate projects and really need this lib.
> 
> I mean, who gives a bother where all that crap lives, if its in the
> kernel tree its all close enough to keep an eye on.. its not like
> kernel/events/ and kernel/trace/ are the same directory.
> 
> Ingo, please could you lighten up and let people get stuff done? Merging
> the two implementations, wherever the result lives, is a better
> situation that two dis-joint implementations. So either let Frederic
> work or do it yourself but don't hand-wave and road-block stuff.

So you are saying that we have patches for a fully unified library and
block it just because we have religious debates about the directory in
which the library code should be?

Some folks should really visit their shrinks!

Thanks,

	tglx

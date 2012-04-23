Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583Ab2DWQHH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 12:07:07 -0400
Received: from mail.skyhub.de ([78.46.96.112]:38064 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753477Ab2DWQHF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 12:07:05 -0400
Date: Mon, 23 Apr 2012 18:07:11 +0200
From: Borislav Petkov <bp@alien8.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Namhyung Kim <namhyung.kim@lge.com>, Jiri Olsa <jolsa@redhat.com>,
        Arun Sharma <asharma@fb.com>, Michael Rubin <mrubin@google.com>,
        David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Julia Lawall <julia@diku.dk>, Tom Zanussi <tzanussi@gmail.com>
Subject: Re: Our failure on tracing tools unification (Was: Re: [RFC][PATCH
 00/15] tools: Unify perf and trace-cmd trace event format parsing v2)
Message-ID: <20120423160710.GA5115@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Steven Rostedt <rostedt@goodmis.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
	Arnaldo Carvalho de Melo <acme@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Namhyung Kim <namhyung.kim@lge.com>, Jiri Olsa <jolsa@redhat.com>,
	Arun Sharma <asharma@fb.com>, Michael Rubin <mrubin@google.com>,
	David Sharp <dhsharp@google.com>,
	Vaibhav Nagarnaik <vnagarnaik@google.com>,
	Julia Lawall <julia@diku.dk>, Tom Zanussi <tzanussi@gmail.com>
References: <1333666086-6517-1-git-send-email-fweisbec@gmail.com>
 <20120423144743.GB29985@somewhere>
 <1335193719.28150.171.camel@twins>
 <1335195100.28106.100.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1335195100.28106.100.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2012 at 11:31:40AM -0400, Steven Rostedt wrote:
> On Mon, 2012-04-23 at 17:08 +0200, Peter Zijlstra wrote:
> > On Mon, 2012-04-23 at 16:47 +0200, Frederic Weisbecker wrote:
> > > Ingo doesn't seem to want this library outside perf in order to avoid
> > > the fragmentation of the efforts on tracing tools.
> > 
> > I really don't see the point.. parsing /debug/tracing/events/*/format
> > gunk really is separate, furthermore things like powertop et al already
> > are separate projects and really need this lib.
> 
> Note, powertop has already pulled in the lib into itself, thus we now
> have 3 dis-joint locations. I can imagine it getting worse soon.

Oh, and there's the mce_record event which I'm going to be needing soon
so this adds yet another user to this library - a minor one but still.

So yeah, we should probably get our stuff in order before going any
further with events and stuff and all...

-- 
Regards/Gruss,
Boris.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278Ab2DWPJO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 11:09:14 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48573 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753557Ab2DWPJN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 11:09:13 -0400
Message-ID: <1335193719.28150.171.camel@twins>
Subject: Re: Our failure on tracing tools unification (Was: Re: [RFC][PATCH
 00/15] tools: Unify perf and trace-cmd trace event format parsing v2)
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>,
        Namhyung Kim <namhyung.kim@lge.com>, Jiri Olsa <jolsa@redhat.com>,
        Arun Sharma <asharma@fb.com>, Michael Rubin <mrubin@google.com>,
        David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Julia Lawall <julia@diku.dk>, Tom Zanussi <tzanussi@gmail.com>
Date: Mon, 23 Apr 2012 17:08:39 +0200
In-Reply-To: <20120423144743.GB29985@somewhere>
References: <1333666086-6517-1-git-send-email-fweisbec@gmail.com>
	 <20120423144743.GB29985@somewhere>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-23 at 16:47 +0200, Frederic Weisbecker wrote:
> Ingo doesn't seem to want this library outside perf in order to avoid
> the fragmentation of the efforts on tracing tools.

I really don't see the point.. parsing /debug/tracing/events/*/format
gunk really is separate, furthermore things like powertop et al already
are separate projects and really need this lib.

I mean, who gives a bother where all that crap lives, if its in the
kernel tree its all close enough to keep an eye on.. its not like
kernel/events/ and kernel/trace/ are the same directory.

Ingo, please could you lighten up and let people get stuff done? Merging
the two implementations, wherever the result lives, is a better
situation that two dis-joint implementations. So either let Frederic
work or do it yourself but don't hand-wave and road-block stuff.

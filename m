Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649Ab2DWPbo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 11:31:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27832 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712Ab2DWPbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 11:31:43 -0400
X-Authority-Analysis: v=2.0 cv=MNHiabll c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=CwwbBQyXtmIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=xqmvskA9eSf5JdJbXC0A:9 a=Jw7HWJvadDMPWtbgsAYA:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1335195100.28106.100.camel@gandalf.stny.rr.com>
Subject: Re: Our failure on tracing tools unification (Was: Re: [RFC][PATCH
 00/15] tools: Unify perf and trace-cmd trace event format parsing v2)
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>,
        Namhyung Kim <namhyung.kim@lge.com>, Jiri Olsa <jolsa@redhat.com>,
        Arun Sharma <asharma@fb.com>, Michael Rubin <mrubin@google.com>,
        David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Julia Lawall <julia@diku.dk>, Tom Zanussi <tzanussi@gmail.com>
Date: Mon, 23 Apr 2012 11:31:40 -0400
In-Reply-To: <1335193719.28150.171.camel@twins>
References: <1333666086-6517-1-git-send-email-fweisbec@gmail.com>
	 <20120423144743.GB29985@somewhere> <1335193719.28150.171.camel@twins>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-23 at 17:08 +0200, Peter Zijlstra wrote:
> On Mon, 2012-04-23 at 16:47 +0200, Frederic Weisbecker wrote:
> > Ingo doesn't seem to want this library outside perf in order to avoid
> > the fragmentation of the efforts on tracing tools.
> 
> I really don't see the point.. parsing /debug/tracing/events/*/format
> gunk really is separate, furthermore things like powertop et al already
> are separate projects and really need this lib.

Note, powertop has already pulled in the lib into itself, thus we now
have 3 dis-joint locations. I can imagine it getting worse soon.

-- Steve

> 
> I mean, who gives a bother where all that crap lives, if its in the
> kernel tree its all close enough to keep an eye on.. its not like
> kernel/events/ and kernel/trace/ are the same directory.
> 
> Ingo, please could you lighten up and let people get stuff done? Merging
> the two implementations, wherever the result lives, is a better
> situation that two dis-joint implementations. So either let Frederic
> work or do it yourself but don't hand-wave and road-block stuff.



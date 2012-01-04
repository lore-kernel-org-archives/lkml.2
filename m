Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292Ab2ADAMG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 19:12:06 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:48678 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755193Ab2ADAME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 19:12:04 -0500
X-Authority-Analysis: v=2.0 cv=A5HuztqG c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=QcgJSxWpgi8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=rHnKkQjduuR3Kv5nxJsA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1325635922.12696.8.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 00/16] [GIT PULL] tracing: fixes/cleanups, no
 stop-machine, update stack tracer
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Tue, 03 Jan 2012 19:12:02 -0500
In-Reply-To: <1325635373.12696.4.camel@gandalf.stny.rr.com>
References: <20111221123624.193898256@goodmis.org>
	 <20120101180949.GA25066@elte.hu> <20120102105856.GA6661@elte.hu>
	 <20120102134856.GA32673@elte.hu>
	 <1325635373.12696.4.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-01-03 at 19:02 -0500, Steven Rostedt wrote:

> I then looked at the merge you did with Linus's branch:
> 
> c7f46b7aa4ae5cbef32eb5e016512a14f936affa
> 
> Checked that out, and booted it twice with your config, and it booted
> without failure both times.

I should have tested this branch more. As I enabled BISECT_CHECK=1 in my
ktest config, it boots both the bad commit and the good commit making
sure the bad commit fails, and the good commit succeeds. The bad did
fail, but so did the good commit, which was Linus's branch.

I booted it again just now, and it failed again.

I'll boot it a couple more times and maybe even recompile. Perhaps I
didn't test Linus's branch correctly (checkout out the wrong branch?).

Thanks,

-- Steve



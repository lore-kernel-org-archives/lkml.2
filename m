Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab1DUPeg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 11:34:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:50063 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754523Ab1DUPef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 11:34:35 -0400
X-Authority-Analysis: v=1.1 cv=pN6kzQkhXdmdOr6Akjoh3kGBD/S3UyPMKQp53EJY+ro= c=1 sm=0 a=czi-rFCAxzMA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=ZIvkPqB8o9qPPm285uMA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC,PATCH 0/3] trace,perf: enabling ftrace/function tracepoint
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>, mingo@redhat.com, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org, Tom Zanussi <tzanussi@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Li Zefan <lizf@cn.fujitsu.com>
In-Reply-To: <20110421152724.GB1772@nowhere>
References: <1303382458-11072-1-git-send-email-jolsa@redhat.com>
	 <20110421152724.GB1772@nowhere>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 21 Apr 2011 11:34:31 -0400
Message-ID: <1303400071.7181.133.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-21 at 17:27 +0200, Frederic Weisbecker wrote:

> So the direction is kinda good but the thing needs to be unglobalized
> (if that word ever exists). Filters need to apply individually to
> each users of the function tracer, that's the trickiest part.
> 
> We also need to catch up with set_ftrace_filter and set_ftrace_notrace
> using filters and triggers, so that we can get rid of the global files
> in the end and have only local effects (per perf_event/ftrace).
> 
> But that's a good start.

Note, As I just finished the last of my "tinkering" jobs, I'm now
starting on my bigger projects. The first being the rewrite of the
ftrace function tracing internals.

I'll start it today, but as I have off tomorrow, and my wife has already
filled all my time up with Honeydew tasks (and this extends into the
weekend), I'll have to continue it next week. But hopefully, if all goes
well, I should have an RFC ready by the end of next week.

-- Steve



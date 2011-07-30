Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329Ab1G3BdG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 21:33:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:36432 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739Ab1G3BdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 21:33:04 -0400
X-Authority-Analysis: v=1.1 cv=sbbt6Wn8j+VvNVI1Ftt/uHhinWyuFt+R57MN9Ty2Tys= c=1 sm=0 a=S531j9xFrh8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=L5IMBajTSogRTMxqaIkA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH v2 1/4] trace-cmd: Add parse error checking target
From: Steven Rostedt <rostedt@goodmis.org>
To: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <CAL26m8JXQxWf-Pj1_KuW=ORUoL9yzEdtgXnQfe7dw0cqPUSURw@mail.gmail.com>
References: <1310785241-3799-1-git-send-email-vnagarnaik@google.com>
	 <1311619188-4905-1-git-send-email-vnagarnaik@google.com>
	 <1311949173.21143.43.camel@gandalf.stny.rr.com>
	 <CAL26m8Jmy=Rcg6fKghk9Epcj9U6Z2i9UM78hF5_r30U5Qvv9uw@mail.gmail.com>
	 <1311962000.21143.69.camel@gandalf.stny.rr.com>
	 <CAL26m8JXQxWf-Pj1_KuW=ORUoL9yzEdtgXnQfe7dw0cqPUSURw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 29 Jul 2011 21:33:02 -0400
Message-ID: <1311989582.21143.111.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-29 at 12:07 -0700, Vaibhav Nagarnaik wrote:
> On Fri, Jul 29, 2011 at 10:53 AM, Steven Rostedt <rostedt@goodmis.org> wrote:

> Our intention with this patch was to reuse the format string parsing
> functionality in trace-cmd to look for any errors in new trace events
> added by various kernel developers. So this was targeted to test for
> event format errors and report them during a new kernel release.

Note, I plan on working on the libperf.so soon and this will allow
plugins to be added for both perf and trace-cmd, and will make depending
on a working print-fmt less.

> 
> A trace.dat file has already recorded all the data from the machine and
> when 'report' is used on it, the format string errors will be reported
> regardless. I don't see how using 'check-events' on a trace.dat file
> would be useful. Thoughts?

Just to see if there's issues in a trace.dat file. But perhaps we could
just add a --check to report. I just figured that it shouldn't be to
hard to add, and may prove useful in the future.

Actually, since plugins may not be on all boxes, and a trace.dat file
can come from anywhere. It could be useful to know if the box you are
reading the trace.dat file has the necessary plugins for it or not.

-- Steve



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756542Ab2BCOHo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 09:07:44 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:40630 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755424Ab2BCOHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 09:07:43 -0500
X-Authority-Analysis: v=2.0 cv=HeuWv148 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=p8-UtJQVZEYA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=P2PrIL1Zq98MBjUml6MA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1328278061.5882.144.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 5/7] ftrace, perf: Add support to use function
 tracepoint in perf
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, mingo@redhat.com,
        paulus@samba.org, acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org, aarapov@redhat.com
Date: Fri, 03 Feb 2012 09:07:41 -0500
In-Reply-To: <20120203130043.GC1531@m.brq.redhat.com>
References: <1326912275-26405-1-git-send-email-jolsa@redhat.com>
	 <1327776209-4883-1-git-send-email-jolsa@redhat.com>
	 <1327776209-4883-6-git-send-email-jolsa@redhat.com>
	 <20120202181409.GH9071@somewhere.redhat.com>
	 <20120203125413.GB1531@m.brq.redhat.com>
	 <20120203130043.GC1531@m.brq.redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-02-03 at 14:00 +0100, Jiri Olsa wrote:

> and use FTRACE_ENTRY_REG for ftrace event like:
> 
> FTRACE_ENTRY_REG(function, ftrace_entry,
>         TRACE_FN,
>         F_STRUCT(
>                 __field(        unsigned long,  ip              )
>                 __field(        unsigned long,  parent_ip       )
>         ),
>         F_printk(" %lx <-- %lx", __entry->ip, __entry->parent_ip),
>         perf_ftrace_event_register
> );

This should be fine.

-- Steve



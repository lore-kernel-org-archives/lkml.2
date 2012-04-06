Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757387Ab2DFPLa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 11:11:30 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:52507 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250Ab2DFPL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 11:11:29 -0400
MIME-Version: 1.0
In-Reply-To: <CAJL_eks9Z62pRsdFH_xE5=RSX7QLqKFtCBifUzH5F2vkhYuGLA@mail.gmail.com>
References: <1333666086-6517-1-git-send-email-fweisbec@gmail.com>
	<CAJL_eks9Z62pRsdFH_xE5=RSX7QLqKFtCBifUzH5F2vkhYuGLA@mail.gmail.com>
Date: Fri, 6 Apr 2012 17:11:29 +0200
Message-ID: <CAFTL4hyr+Oy4MEityw6PY3u11MhziSFLg=OB5yh6XFJwWD3QAw@mail.gmail.com>
Subject: Re: [RFC][PATCH 00/15] tools: Unify perf and trace-cmd trace event
 format parsing v2
From: Frederic Weisbecker <fweisbec@gmail.com>
To: David Sharp <dhsharp@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, Jiri Olsa <jolsa@redhat.com>,
        Arun Sharma <asharma@fb.com>, Namhyung Kim <namhyung.kim@lge.com>,
        Michael Rubin <mrubin@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Julia Lawall <julia@diku.dk>, Tom Zanussi <tzanussi@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/4/6 David Sharp <dhsharp@google.com>:
> On Thu, Apr 5, 2012 at 3:47 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>>
>> Hi,
>>
>> So this is a new iteration of the libtracevent library, basically a
>> rebase of https://lkml.org/lkml/2011/8/5/299 against latest progresses
>> (latest tip/perf/core + tip/perf/urgent).
>>
>> This library unifies the trace events parsing code between perf and
>> trace-cmd. I initially took this parsing code from trace-cmd to make
>> perf able to display trace-events and play with their contents.
>
> Hi Frederic. Thanks for taking this on.
>
> Could you consider adding these patches to this set?
> https://lkml.org/lkml/2011/3/21/335

Oh sure! I'll catch up with the commits I missed in trace-cmd.

Thanks!

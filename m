Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871Ab2EGIiI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 04:38:08 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:64283 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755497Ab2EGIiG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 04:38:06 -0400
X-AuditID: 9c930179-b7c19ae000000486-ad-4fa789ea1b35
From: Namhyung Kim <namhyung.kim@lge.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, Jiri Olsa <jolsa@redhat.com>,
        Arun Sharma <asharma@fb.com>, Michael Rubin <mrubin@google.com>,
        David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Julia Lawall <julia@diku.dk>, Tom Zanussi <tzanussi@gmail.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 00/15] tools: Unify perf and trace-cmd trace event format parsing v3
References: <1335356819-16710-1-git-send-email-fweisbec@gmail.com>
	<20120507081424.GE16608@gmail.com>
Date: Mon, 07 May 2012 17:36:42 +0900
In-Reply-To: <20120507081424.GE16608@gmail.com> (Ingo Molnar's message of
	"Mon, 7 May 2012 10:14:24 +0200")
Message-ID: <87vck8qtet.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 7 May 2012 10:14:24 +0200, Ingo Molnar wrote:
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
>
>> Hi,
>> 
>> This is essentially a rebase against latest tip:perf/core updates.
>> Mostly due to conflicts against the perf Makefile updates.
>> 
>> I think we all agree that this library needs improvements but these
>> should rather be done incrementally. The current perf trace event parsing
>> is anyway much backward compared to that library.
>> 
>> Default target is a static library in tools/libtraceevent/libtraceevent.a
>> 
>> This can be pulled from:
>> 
>> git://github.com/fweisbec/tracing.git
>> 	perf/parse-events-4
>
> It gives me:
>
> /home/mingo/tip/tools/lib/traceevent/parse-filter.c: In function ‘create_arg_item’:
> /home/mingo/tip/tools/lib/traceevent/parse-filter.c:343:9: warning: comparison between ‘enum filter_arg_type’ and ‘enum event_type’ [-Wenum-compare]
> /home/mingo/tip/tools/lib/traceevent/parse-filter.c:339:2: warning: case value ‘8’ not in enumerated type ‘enum filter_arg_type’ [-Wswitch]
>
> Had this been in tools/perf/ it would use -Werror already and 
> you'd have fixed it, not requiring me to unpull these bits :-/
>

I already submitted a patch for it (along with other fixes) to Steven.

  lkml.indiana.edu/hypermail/linux/kernel/1204.2/03713.html


Thanks,
Namhyung


> So can we please make a libevent.so, built sanely within 
> tools/perf/lib/ or such and distributed together with perf so 
> that the two can never get out of sync?
>
> Thanks,
>
> 	Ingo

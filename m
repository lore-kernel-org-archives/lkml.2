Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933257Ab1KCM5R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 08:57:17 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:39222 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755841Ab1KCM5Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 08:57:16 -0400
Message-ID: <4EB28FA6.3040204@gmail.com>
Date: Thu, 03 Nov 2011 16:57:10 +0400
From: Andrew Vagin <avagin@gmail.com>
Reply-To: avagin@gmail.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc13 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Andrew Vagin <avagin@openvz.org>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, devel@openvz.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: Re: [PATCH] event: fix TP_printk() argument in sched_switch
References: <1320273611-2463347-1-git-send-email-avagin@openvz.org> <1320275277.4793.54.camel@gandalf.stny.rr.com>
In-Reply-To: <1320275277.4793.54.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> NACK!
>
> This is a perf userspace bug, not a kernel one. Please fix the userspace
> tool instead.
>
> Note, the new version of libparsevent handles this case without issue.
> Perf just needs to be updated.
I don't understand. I've got 
git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git
and it reports the same error. Where am I wrong?

# ./trace-cmd report 2> log

<idle>-0     [001] 1516333.292126: sched_switch:         [FAILED TO 
PARSE] prev_comm=kworker/0:0 prev_pid=0 prev_prio=120 prev_state=0x0 
next_comm=trace-cmd next_pid=2900 next_prio=120

# cat log
trace-cmd: No such file or directory
   Error: expected type 5 but read 4
   Error: expected type 4 but read 0
   failed to read event print fmt for sched_switch
trace-cmd: Received SIGINT

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644Ab1KCOBE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 10:01:04 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:46274 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255Ab1KCOBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 10:01:03 -0400
Message-ID: <4EB29E9C.1010004@gmail.com>
Date: Thu, 03 Nov 2011 08:01:00 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: avagin@gmail.com
CC: Steven Rostedt <rostedt@goodmis.org>, Andrew Vagin <avagin@openvz.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, devel@openvz.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: Re: [PATCH] event: fix TP_printk() argument in sched_switch
References: <1320273611-2463347-1-git-send-email-avagin@openvz.org> <1320275277.4793.54.camel@gandalf.stny.rr.com> <4EB28FA6.3040204@gmail.com>
In-Reply-To: <4EB28FA6.3040204@gmail.com>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/2011 06:57 AM, Andrew Vagin wrote:
> 
>> NACK!
>>
>> This is a perf userspace bug, not a kernel one. Please fix the userspace
>> tool instead.
>>
>> Note, the new version of libparsevent handles this case without issue.
>> Perf just needs to be updated.
> I don't understand. I've got
> git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git
> and it reports the same error. Where am I wrong?

Have you installed the plugins?

David

> 
> # ./trace-cmd report 2> log
> 
> <idle>-0     [001] 1516333.292126: sched_switch:         [FAILED TO
> PARSE] prev_comm=kworker/0:0 prev_pid=0 prev_prio=120 prev_state=0x0
> next_comm=trace-cmd next_pid=2900 next_prio=120
> 
> # cat log
> trace-cmd: No such file or directory
>   Error: expected type 5 but read 4
>   Error: expected type 4 but read 0
>   failed to read event print fmt for sched_switch
> trace-cmd: Received SIGINT
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

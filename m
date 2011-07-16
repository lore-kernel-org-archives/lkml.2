Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476Ab1GPKaz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 06:30:55 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:57290 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950Ab1GPKaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 06:30:52 -0400
X-AuditID: b753bd60-a32aeba0000019f4-d2-4e216859574b
X-AuditID: b753bd60-a32aeba0000019f4-d2-4e216859574b
Message-ID: <4E21684F.8000905@hitachi.com>
Date: Sat, 16 Jul 2011 19:30:39 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH -tip 02/13] [CLEANUP]tracing/kprobes: merge trace probe
 enable/disable functions
References: <20110627072626.6528.41792.stgit@fedora15>  <20110627072644.6528.26910.stgit@fedora15> <1310750862.27864.71.camel@gandalf.stny.rr.com>
In-Reply-To: <1310750862.27864.71.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/07/16 2:27), Steven Rostedt wrote:
> On Mon, 2011-06-27 at 16:26 +0900, Masami Hiramatsu wrote:
>> Merge redundant enable/disable functions into enable_trace_probe()
>> and disable_trace_probe().
>>
>> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
>> Cc: Steven Rostedt <rostedt@goodmis.org>
>> Cc: Frederic Weisbecker <fweisbec@gmail.com>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> ---
> 
> This patch failed to compile with:
> 
> /home/rostedt/work/autotest/nobackup/linux-test.git/kernel/trace/trace_kprobe.c: In function 'kprobe_trace_self_tests_init':
> /home/rostedt/work/autotest/nobackup/linux-test.git/kernel/trace/trace_kprobe.c:1888:4: error: implicit declaration of function 'probe_event_enable'
> 

Oops, it was my fault... I'll update it soon.

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com

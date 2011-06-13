Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161Ab1FMKwQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 06:52:16 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:55806 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002Ab1FMKwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 06:52:15 -0400
X-AuditID: b753bd60-a3cc8ba000003bac-17-4df5ebdc8e67
X-AuditID: b753bd60-a3cc8ba000003bac-17-4df5ebdc8e67
Message-ID: <4DF5EBD4.7070207@hitachi.com>
Date: Mon, 13 Jun 2011 19:52:04 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Namhyung Kim <namhyung@gmail.com>
Subject: Re: [PATCH 14/15] stack_trace: Add weak save_stack_trace_regs()
References: <20110609172744.333794089@goodmis.org> <20110609172914.028158916@goodmis.org> <20110613101955.GE30962@elte.hu>
In-Reply-To: <20110613101955.GE30962@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/06/13 19:19), Ingo Molnar wrote:
> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
>> +save_stack_trace_regs(struct pt_regs *regs, struct stack_trace *trace)
>> +{
>> +	WARN_ONCE(1,
>> +		  KERN_INFO "save_stack_trace_regs() not implemented yet.\n");
> 
>  - pointless linebreak
>  - we don't add KERN_ tags to WARN*() invocations

Hm, I just copied save_stack_trace_tsk(). OK, I'll remove it.

Thanks!

> 
> Thanks,
> 
> 	Ingo


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090Ab2DMG2G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 02:28:06 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:38358 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754287Ab2DMG2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 02:28:04 -0400
X-AuditID: b753bd60-96f90ba000007b1b-88-4f87c7710448
X-AuditID: b753bd60-96f90ba000007b1b-88-4f87c7710448
Message-ID: <4F87C76B.10001@hitachi.com>
Date: Fri, 13 Apr 2012 15:27:55 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Oleg Nesterov <oleg@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Anton Arapov <anton@redhat.com>
Subject: Re: [PATCH] perf/probe: Provide perf interface for uprobes
References: <20120411135742.29198.45061.sendpatchset@srdronam.in.ibm.com> <20120411144918.GD16257@infradead.org> <20120411170343.GB29831@linux.vnet.ibm.com> <20120411181727.GK16257@infradead.org> <4F864BB3.3090405@hitachi.com> <20120412140751.GM16257@infradead.org> <20120412151037.GC21587@linux.vnet.ibm.com>
In-Reply-To: <20120412151037.GC21587@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/04/13 0:10), Srikar Dronamraju wrote:
>>  $ perf probe libc malloc
>>
>> 	Makes it even easier to use.
>>
>> 	Its just when one asks for something that has ambiguities that
>> the tool should ask the user to be a bit more precise to remove such
>> ambiguity.
>>
>> 	After all...
>>
> 
> Another case 
> perf probe do_fork clone_flags now looks for variable clone_flags in
> kernel function do_fork.
> 
> But if we allow to trace perf probe zsh zfree; then 
> 'perf probe do_fork clone_flags' should it check for do_fork executable
> or not? If it does check and finds one, and searches for clone_flags
> function and doesnt find, then should it continue with searching the
> kernel?
> 

Agree. I'd like to suggest you to start with only full path support,
and see, how we can handle abbreviations :)

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com

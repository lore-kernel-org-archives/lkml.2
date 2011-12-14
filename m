Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757521Ab1LNQrr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 11:47:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59840 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756194Ab1LNQrn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 11:47:43 -0500
Message-ID: <4EE8D305.8020407@zytor.com>
Date: Wed, 14 Dec 2011 08:47:01 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org
Subject: Re: linux-next: build warnings after merge of the final tree
References: <20111214181545.6e13bc954cb7ddce9086e861@canb.auug.org.au> <1323880322.23971.33.camel@gandalf.stny.rr.com>
In-Reply-To: <1323880322.23971.33.camel@gandalf.stny.rr.com>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2011 08:32 AM, Steven Rostedt wrote:
> On Wed, 2011-12-14 at 18:15 +1100, Stephen Rothwell wrote:
> 
>> Maybe caused by commit d5e553d6e0a4 ("trace: Include <asm/asm-offsets.h>
>> in trace_syscalls.c") from the tip tree.  These warnings may have been
>> here for a while as it is hard to catch the new ones among the flood.
>>
> 
> hpa,
> 
> Was this change only needed for x86? If so, could you put that into
> asm/ftrace.h instead?
> 

Yes (on both accounts).  It was part of the syscall changes; I'll move
the include.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


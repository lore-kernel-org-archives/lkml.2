Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555Ab2HGPfH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 11:35:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18786 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751077Ab2HGPfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 11:35:04 -0400
Date: Tue, 7 Aug 2012 17:31:31 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Roland McGrath <roland@hack.frob.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ptrace: fix
	set_task_blockstep()->update_debugctlmsr() logic
Message-ID: <20120807153131.GA14238@redhat.com>
References: <20120803162954.GA19806@redhat.com> <5020E2E4.3090104@linutronix.de> <20120807151531.GC13476@redhat.com> <50213462.5040304@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50213462.5040304@linutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07, Sebastian Andrzej Siewior wrote:
>
> On 08/07/2012 05:15 PM, Oleg Nesterov wrote:
>> It turns out, original code is even more buggy than I thought.
>>
>> Ironically, "task != current" case is more difficult and so far
>> I do not see how we can handle this case correctly. I'll return
>> to this a bit later, currently I am working on other patches.
>
> maybe you could remove the autodectect mode and add helper for uprobe
> which disables it.

No, this won't help.

So. Sorry for delay, I'll try to return to this tomorrow. Today
I spent THE WHOLE DAY trying to understand what is wrong with my
emails, and I did nothing else.

Oleg.


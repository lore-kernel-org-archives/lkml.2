Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934290Ab0EEJ65 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 05:58:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:54989 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932412Ab0EEJ64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 05:58:56 -0400
Message-ID: <4BE14141.9020006@kernel.org>
Date: Wed, 05 May 2010 11:58:25 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: Peter Zijlstra <peterz@infradead.org>, mingo@elte.hu, efault@gmx.de,
       avi@redhat.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/12] perf: add @rq to perf_event_task_sched_out()
References: <1272976724-14312-1-git-send-email-tj@kernel.org>	 <1272976724-14312-5-git-send-email-tj@kernel.org>	 <1272993090.1642.184.camel@laptop>  <4BE057EB.80604@kernel.org>	 <1272997363.9739.232.camel@gandalf.stny.rr.com>	 <1272997616.1642.207.camel@laptop> <1272997930.9739.233.camel@gandalf.stny.rr.com>
In-Reply-To: <1272997930.9739.233.camel@gandalf.stny.rr.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 05 May 2010 09:58:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/2010 08:32 PM, Steven Rostedt wrote:
>> ---
>>  include/trace/events/sched.h      |   32 ++++++++++----------------------
>>  kernel/sched.c                    |    8 ++++----
>>  kernel/trace/trace_sched_wakeup.c |    5 ++---
>>  3 files changed, 16 insertions(+), 29 deletions(-)
> 
> Acked-by: Steven Rostedt <rostedt@goodmis.org>

Peter, can I include this patch into my series?  If so, can you please
post a patch w/ description?

Thanks.

-- 
tejun

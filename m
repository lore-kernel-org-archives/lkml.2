Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095Ab0EEEs4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 00:48:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:51956 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750894Ab0EEEsz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 00:48:55 -0400
Message-ID: <4BE0F882.9080206@kernel.org>
Date: Wed, 05 May 2010 06:48:02 +0200
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
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 05 May 2010 04:48:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/2010 08:32 PM, Steven Rostedt wrote:
>>> I believe the rq was used by the original latency tracer code that was
>>> in the -rt patch set before ftrace. It is most likely there for
>>> historical purposes. I guess it would be fine to just remove it.
>>
>> I'm building the below, so far so good... ;-)
> 
> Acked-by: Steven Rostedt <rostedt@goodmis.org>

Cool, then I can remove SCHED_EVENT_RQ() thing then.

Thanks.

-- 
tejun

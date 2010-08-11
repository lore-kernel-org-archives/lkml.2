Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995Ab0HKHyI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 03:54:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:36144 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753128Ab0HKHyG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 03:54:06 -0400
Message-ID: <4C6256B4.1030304@kernel.org>
Date: Wed, 11 Aug 2010 09:52:20 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Namhyung Kim <namhyung@gmail.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf, tracing: add missing __percpu markups
References: <1281498479-28551-1-git-send-email-namhyung@gmail.com>
In-Reply-To: <1281498479-28551-1-git-send-email-namhyung@gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 11 Aug 2010 07:53:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/2010 05:47 AM, Namhyung Kim wrote:
> ftrace_event_call->perf_events, perf_trace_buf, fgraph_data->cpu_data and
> some local variables are percpu pointers but were missing __percpu markup.
> Add it.
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a mersage to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756273Ab2A0QgY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 11:36:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30004 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752148Ab2A0QgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 11:36:23 -0500
Message-ID: <4F22D265.9040303@redhat.com>
Date: Fri, 27 Jan 2012 11:35:49 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Rafael Aquini <aquini@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [resubmit] Re: [PATCH] tracing: adjust shrink_slab beginning
 trace event name
References: <20111223141619.GA19720@x61.redhat.com> <20120127124405.GA2092@x61.redhat.com>
In-Reply-To: <20120127124405.GA2092@x61.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2012 07:44 AM, Rafael Aquini wrote:
> While reviewing vmscan tracing events, I realized all functions which establish paired tracepoints (one at the beginning and another at the end of the function block) were following this naming pattern:
>    <tracepoint-name>_begin
>    <tarcepoint-name>_end
>
> However, the 'beginning' tracing event for shrink_slab() did not follow the aforementioned naming pattern. This patch renames that trace event to adjust this naming inconsistency.
>
> Signed-off-by: Rafael Aquini<aquini@redhat.com>
> Reviewed-by: Minchan Kim<minchan@kernel.org>
> Acked-by: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed

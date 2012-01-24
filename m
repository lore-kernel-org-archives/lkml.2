Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749Ab2AXA1m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 19:27:42 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:52211 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363Ab2AXA1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 19:27:41 -0500
X-AuditID: b753bd60-99661ba00000359c-63-4f1dfafa9faa
X-AuditID: b753bd60-99661ba00000359c-63-4f1dfafa9faa
Message-ID: <4F1DFAE0.5020103@hitachi.com>
Date: Tue, 24 Jan 2012 09:27:12 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [TRIVIAL] perf probe usability related fixes.
References: <20120120121354.GL15447@linux.vnet.ibm.com>
In-Reply-To: <20120120121354.GL15447@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/01/20 21:13), Srikar Dronamraju wrote:
> From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> 
> Ingo pointed out few perf probe usability related errors during
> his review of uprobes.
> 
> Since these issues are independent of uprobes, fixing them in a
> separate patch.
> 
> Suggested-by: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thanks!

> ---
>  tools/perf/util/probe-event.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
> index f6f5794..da38ec5 100644
> --- a/tools/perf/util/probe-event.c
> +++ b/tools/perf/util/probe-event.c
> @@ -1825,7 +1825,7 @@ static int __add_probe_trace_events(struct perf_probe_event *pev,
>  	}
>  
>  	ret = 0;
> -	printf("Add new event%s\n", (ntevs > 1) ? "s:" : ":");
> +	printf("Added new event%s\n", (ntevs > 1) ? "s:" : ":");
>  	for (i = 0; i < ntevs; i++) {
>  		tev = &tevs[i];
>  		if (pev->event)
> @@ -1880,7 +1880,7 @@ static int __add_probe_trace_events(struct perf_probe_event *pev,
>  
>  	if (ret >= 0) {
>  		/* Show how to use the event. */
> -		printf("\nYou can now use it on all perf tools, such as:\n\n");
> +		printf("\nYou can now use it in all perf tools, such as:\n\n");
>  		printf("\tperf record -e %s:%s -aR sleep 1\n\n", tev->group,
>  			 tev->event);
>  	}
> @@ -2063,7 +2063,7 @@ static int __del_trace_probe_event(int fd, struct str_node *ent)
>  		goto error;
>  	}
>  
> -	printf("Remove event: %s\n", ent->s);
> +	printf("Removed event: %s\n", ent->s);
>  	return 0;
>  error:
>  	pr_warning("Failed to delete event: %s\n", strerror(-ret));
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com

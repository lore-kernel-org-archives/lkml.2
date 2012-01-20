Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab2ATOrT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 09:47:19 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45156 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265Ab2ATOrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 09:47:17 -0500
Message-ID: <4F197E6F.5070003@gmail.com>
Date: Fri, 20 Jan 2012 07:47:11 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
CC: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [TRIVIAL] perf probe usability related fixes.
References: <20120120121354.GL15447@linux.vnet.ibm.com>
In-Reply-To: <20120120121354.GL15447@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2012 05:13 AM, Srikar Dronamraju wrote:
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

It's not past tense until after write_probe_trace_event() right? Where
the message is now you can get an error message after that printf.

David


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757081Ab1LBQyb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 11:54:31 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58997 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755807Ab1LBQya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 11:54:30 -0500
Message-ID: <4ED902C0.5020300@gmail.com>
Date: Fri, 02 Dec 2011 09:54:24 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, arnaldo.melo@gmail.com
Subject: Re: [GIT PULL 0/4] perf test improvements
References: <1322842769-7232-1-git-send-email-acme@infradead.org>
In-Reply-To: <1322842769-7232-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/02/2011 09:19 AM, Arnaldo Carvalho de Melo wrote:
> Hi Ingo,
> 
>         Please consider pulling from:
> 
> git://github.com/acmel/linux.git perf/core
> 
> 	Now there are 29 outstanding changesets on this branch.

What about the 2 commits on your urgent branch? I don't recall seeing a
response that those were picked up, and they are not in Linus' branch.

David


> 
> Regards,
> 
> - Arnaldo
> 
> Arnaldo Carvalho de Melo (4):
>   perf evlist: Always do automatic allocation of pollfd and mmap structures
>   perf test: Allow running just a subset of the available tests
>   perf event: Introduce perf_event__fprintf
>   perf test: Validate PERF_RECORD_ events and perf_sample fields
> 
>  tools/perf/Documentation/perf-test.txt |    8 +-
>  tools/perf/builtin-record.c            |    6 -
>  tools/perf/builtin-stat.c              |    3 +-
>  tools/perf/builtin-test.c              |  418 ++++++++++++++++++++++++++++++--
>  tools/perf/builtin-top.c               |   19 +--
>  tools/perf/util/event.c                |   54 ++++-
>  tools/perf/util/event.h                |    6 +
>  tools/perf/util/evlist.c               |    4 +-
>  tools/perf/util/evlist.h               |    2 -
>  9 files changed, 465 insertions(+), 55 deletions(-)
> 

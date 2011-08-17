Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538Ab1HQVhh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 17:37:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:57954 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751570Ab1HQVhg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 17:37:36 -0400
Date: Wed, 17 Aug 2011 23:36:17 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        David Ahern <daahern@cisco.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, acme@ghostprotocols.net
Subject: Re: [GIT PULL 0/6] perf/core fixes and improvements
Message-ID: <20110817213617.GA9634@kernel.org>
References: <1313505695-20724-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313505695-20724-1-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (hera.kernel.org [127.0.0.1]); Wed, 17 Aug 2011 21:37:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> Hi Ingo,
> 
>         Please consider pulling from:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux perf/core
> 
> Regards,
> 
> - Arnaldo
> 
> Stephane Eranian (6):
>   perf list: Fix exit value
>   perf evlist: Fix missing event name init for default event (v2)
>   perf tools: Fix error handling of unknown events
>   perf annotate: Make output more readable
>   perf annotate: Add --symfs option
>   perf stat: Add -o and --append options
> 
>  tools/perf/Documentation/perf-annotate.txt |   11 ++
>  tools/perf/Documentation/perf-stat.txt     |    7 ++
>  tools/perf/builtin-annotate.c              |    6 +
>  tools/perf/builtin-stat.c                  |  155 ++++++++++++++++-----------
>  tools/perf/util/annotate.c                 |    5 +-
>  tools/perf/util/color.c                    |    2 +-
>  tools/perf/util/evlist.c                   |   11 ++-
>  tools/perf/util/parse-events.c             |    8 +-
>  tools/perf/util/symbol.c                   |    2 +
>  tools/perf/util/symbol.h                   |    4 +-
>  10 files changed, 141 insertions(+), 70 deletions(-)

hm, shouldnt these:

>   perf list: Fix exit value
>   perf evlist: Fix missing event name init for default event (v2)
>   perf tools: Fix error handling of unknown events

be in perf/urgent (based on -git) and go into v3.1, while the rest is 
for perf/core and goes into v3.2?

Thanks,

	Ingo

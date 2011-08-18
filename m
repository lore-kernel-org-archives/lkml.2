Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372Ab1HRU2t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 16:28:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:47305 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293Ab1HRU2s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 16:28:48 -0400
Date: Thu, 18 Aug 2011 22:27:34 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        David Ahern <daahern@cisco.com>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, arnaldo.melo@gmail.com
Subject: Re: [GIT PULL 0/3] perf/core improvements
Message-ID: <20110818202734.GA28969@kernel.org>
References: <1313695870-31028-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313695870-31028-1-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (hera.kernel.org [127.0.0.1]); Thu, 18 Aug 2011 20:28:34 +0000 (UTC)
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
> Stephane Eranian (3):
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
>  tools/perf/util/symbol.c                   |    2 +
>  tools/perf/util/symbol.h                   |    4 +-
>  8 files changed, 126 insertions(+), 66 deletions(-)

Pulled these and the urgent bits as well - thanks a lot Arnaldo!

	Ingo

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932573Ab2EXK3j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 06:29:39 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:36434 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754837Ab2EXK3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 06:29:38 -0400
Date: Thu, 24 May 2012 12:29:31 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, arnaldo.melo@gmail.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 0/1] perf/core fix
Message-ID: <20120524102931.GA3148@gmail.com>
References: <1337821705-3941-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337821705-3941-1-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> Hi Ingo,
> 
> 	Please pull,
> 
> - Arnaldo
> 
> The following changes since commit ab0cce560ef177bdc7a8f73e9962be9d829a7b2c:
> 
>   Revert "sched, perf: Use a single callback into the scheduler" (2012-05-23 17:40:51 +0200)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux perf/core
> 
> for you to fetch changes up to a1d44b9acdf7b2820ef762846150b4d13b84e075:
> 
>   perf evlist: Explicititely initialize input_name (2012-05-23 21:47:51 -0300)
> 
> ----------------------------------------------------------------
> Fix perf evlist uninitialized local variable
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> ----------------------------------------------------------------
> Arnaldo Carvalho de Melo (1):
>       perf evlist: Explicititely initialize input_name
> 
>  tools/perf/builtin-evlist.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Pulled, thanks Arnaldo!

	Ingo

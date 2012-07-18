Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020Ab2GRCUd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 22:20:33 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:51375 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491Ab2GRCUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 22:20:24 -0400
X-AuditID: 9c930197-b7b66ae000006a2c-fb-50061d65077f
From: Namhyung Kim <namhyung@kernel.org>
To: Masanari Iida <standby24x7@gmail.com>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH 1/2] [trivial] tools: perf: Fix typo in tools/perf
References: <1342542059-9756-1-git-send-email-standby24x7@gmail.com>
Date: Wed, 18 Jul 2012 11:15:27 +0900
In-Reply-To: <1342542059-9756-1-git-send-email-standby24x7@gmail.com>
	(Masanari Iida's message of "Wed, 18 Jul 2012 01:20:59 +0900")
Message-ID: <87eho93jcw.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Masanari

On Wed, 18 Jul 2012 01:20:59 +0900, Masanari Iida wrote:
> Correct spelling typo in tools/perf.
>
> Signed-off-by: Masanari iida <standby24x7@gmail.com>
> ---
>  tools/perf/util/callchain.h         | 2 +-
>  tools/perf/util/parse-events-test.c | 2 +-
>  tools/perf/util/python-ext-sources  | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
> index 3bdb407..eb34057 100644
> --- a/tools/perf/util/callchain.h
> +++ b/tools/perf/util/callchain.h
> @@ -58,7 +58,7 @@ struct callchain_list {
>  /*
>   * A callchain cursor is a single linked list that
>   * let one feed a callchain progressively.
> - * It keeps persitent allocated entries to minimize
> + * It keeps persistent allocated entries to minimize

s/persistent/persistently/ ?

Thanks,
Namhyung


>   * allocations.
>   */
>  struct callchain_cursor_node {
> diff --git a/tools/perf/util/parse-events-test.c b/tools/perf/util/parse-events-test.c
> index 76b98e2..8cdf147 100644
> --- a/tools/perf/util/parse-events-test.c
> +++ b/tools/perf/util/parse-events-test.c
> @@ -609,7 +609,7 @@ static int test_pmu(void)
>  
>  	ret = stat(path, &st);
>  	if (ret)
> -		pr_debug("ommiting PMU cpu tests\n");
> +		pr_debug("omitting PMU cpu tests\n");
>  	return !ret;
>  }
>  
> diff --git a/tools/perf/util/python-ext-sources b/tools/perf/util/python-ext-sources
> index 2884e67..f4e37ce 100644
> --- a/tools/perf/util/python-ext-sources
> +++ b/tools/perf/util/python-ext-sources
> @@ -1,5 +1,5 @@
>  #
> -# List of files needed by perf python extention
> +# List of files needed by perf python extension
>  #
>  # Each source file must be placed on its own line so that it can be
>  # processed by Makefile and util/setup.py accordingly.

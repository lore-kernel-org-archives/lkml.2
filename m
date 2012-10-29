Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757036Ab2J2Kts (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 06:49:48 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:45479 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058Ab2J2Ktr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 06:49:47 -0400
X-AuditID: 9c930197-b7c4aae000004160-d1-508e5f4925b8
From: Namhyung Kim <namhyung@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        jolsa@redhat.com, eranian@google.com, mingo@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 21/33] perf, tools: Add support for record transaction flags
References: <1351283415-13170-1-git-send-email-andi@firstfloor.org>
	<1351283415-13170-22-git-send-email-andi@firstfloor.org>
Date: Mon, 29 Oct 2012 19:49:45 +0900
In-Reply-To: <1351283415-13170-22-git-send-email-andi@firstfloor.org> (Andi
	Kleen's message of "Fri, 26 Oct 2012 13:30:03 -0700")
Message-ID: <87r4oh7dti.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Oct 2012 13:30:03 -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
>
> Add the glue in the user tools to record transaction flags with
> --transaction (-T was already taken) and dump them.
>
> Followon patches will use them.
>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  tools/perf/Documentation/perf-record.txt |    5 ++++-
>  tools/perf/builtin-record.c              |    2 ++
>  tools/perf/perf.h                        |    1 +
>  tools/perf/util/event.h                  |    1 +
>  tools/perf/util/evsel.c                  |    9 +++++++++
>  tools/perf/util/session.c                |    3 +++
>  6 files changed, 20 insertions(+), 1 deletions(-)
>
> diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
> index 0ffb436..34f4f1a 100644
> --- a/tools/perf/Documentation/perf-record.txt
> +++ b/tools/perf/Documentation/perf-record.txt
> @@ -185,12 +185,15 @@ is enabled for all the sampling events. The sampled branch type is the same for
>  The various filters must be specified as a comma separated list: --branch-filter any_ret,u,k
>  Note that this feature may not be available on all processors.
>  
> --W::
>  --weight::
>  Enable weightened sampling. When the event supports an additional weight per sample scale
>  the histogram by this weight. This currently works for TSX abort events and some memory events
>  in precise mode on modern Intel CPUs.
>  
> +-T::

No, as you said, -T was already taken. ;)

Thanks,
Namhyung


> +--transaction::
> +Record transaction flags for transaction related events.
> +
>  SEE ALSO
>  --------
>  linkperf:perf-stat[1], linkperf:perf-list[1]

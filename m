Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932397Ab2J2LHv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 07:07:51 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:61216 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932307Ab2J2LHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 07:07:49 -0400
X-AuditID: 9c93016f-b7c7bae000000eb7-0d-508e63847adb
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 0/5] perf dso: Separate dso symbols to separate object
References: <1351372712-21104-1-git-send-email-jolsa@redhat.com>
Date: Mon, 29 Oct 2012 20:07:48 +0900
In-Reply-To: <1351372712-21104-1-git-send-email-jolsa@redhat.com> (Jiri Olsa's
	message of "Sat, 27 Oct 2012 23:18:27 +0200")
Message-ID: <87mwz57czf.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Sat, 27 Oct 2012 23:18:27 +0200, Jiri Olsa wrote:
> hi,
> separating dso related stuff into dso object plus some other symbol
> object cleanup. It's just a code moving, no actual change was done.
>
> Attached patches:
>   1/5 perf tool: Move build_id__sprintf into build-id object
>   2/5 perf tool: Move BUILD_ID_SIZE into build-id object
>   3/5 perf tool: Move hex2u64 into util object
>   4/5 perf tool: Move strxfrchar into string object
>   5/5 perf tool: Move dso_* related functions into dso object

Looks good to me.

Arnaldo, if you want, you can add my Reviewed- or Tested-by tags for this
series.

Thanks,
Namhyung

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751781Ab2JVIxg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 04:53:36 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:59789 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793Ab2JVIxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 04:53:35 -0400
X-AuditID: 9c930197-b7c4aae000004160-9b-5085098d145f
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 00/11] perf tool: Add PERF_SAMPLE_READ sample read support
References: <1350743599-4805-1-git-send-email-jolsa@redhat.com>
	<87ipa3j72c.fsf@sejong.aot.lge.com>
	<20121022075304.GA984@krava.brq.redhat.com>
Date: Mon, 22 Oct 2012 17:53:32 +0900
In-Reply-To: <20121022075304.GA984@krava.brq.redhat.com> (Jiri Olsa's message
	of "Mon, 22 Oct 2012 09:53:05 +0200")
Message-ID: <876262khv7.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Oct 2012 09:53:05 +0200, Jiri Olsa wrote:
> On Mon, Oct 22, 2012 at 04:32:11PM +0900, Namhyung Kim wrote:
>> It'd be better if you provide a git branch for this series.
>
> aaah right, I forgot to mention that.. ;)
>
> git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/linux.git
> perf/group2

I couldn't get the branch.  Do you mind rechecking?

$ git fetch git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/linux.git perf/group2
fatal: Couldn't find remote ref perf/group2

Thanks,
Namhyung

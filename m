Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751726Ab2LQEze (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 23:55:34 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:65262 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987Ab2LQEzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 23:55:33 -0500
X-AuditID: 9c930197-b7c5bae000000e31-22-50cea5c3aa62
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 00/14] perf, diff: multiple perf.data file support
References: <1355404152-16523-1-git-send-email-jolsa@redhat.com>
Date: Mon, 17 Dec 2012 13:55:31 +0900
In-Reply-To: <1355404152-16523-1-git-send-email-jolsa@redhat.com> (Jiri Olsa's
	message of "Thu, 13 Dec 2012 14:08:58 +0100")
Message-ID: <87sj75l1ks.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Thu, 13 Dec 2012 14:08:58 +0100, Jiri Olsa wrote:
> hi,
> adding support to display diff for more than 2 perf.data files.
>
> The basic idea is describe in the initial RFC in here:
> https://lkml.org/lkml/2012/11/28/200
>
> It's rebased on current Arnaldo's perf core with Namhyung's
> changes.

For the whole series:

Reviewed-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung

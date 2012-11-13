Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914Ab2KMC0L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 21:26:11 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:55562 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386Ab2KMC0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 21:26:09 -0500
X-AuditID: 9c930179-b7c9dae000000e53-11-50a1afc05b33
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 0/5] perf tool: Fix enable/disable events logic for record command
References: <1352741644-16809-1-git-send-email-jolsa@redhat.com>
Date: Tue, 13 Nov 2012 11:26:08 +0900
In-Reply-To: <1352741644-16809-1-git-send-email-jolsa@redhat.com> (Jiri Olsa's
	message of "Mon, 12 Nov 2012 18:33:59 +0100")
Message-ID: <87d2zime67.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Nov 2012 18:33:59 +0100, Jiri Olsa wrote:
> hi,
> this patchset fixes the event enable/disable logic for record command
> (patches 1 - 4) plus small fix for event parsing (patch 5).
>
> Attached patches:
>   1/5 perf tool: Fix attributes for '{}' defined event groups
>   2/5 perf tool: Fix 'disabled' attribute config for record command
>   3/5 perf tool: Ensure single disable call per event in record comand
>   4/5 perf tool: Omit group members from perf_evlist__disable/enable
>   5/5 perf tool: Add basic event modifier sanity check
>
> Also available in:
> git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/linux.git
> perf/enable5
>
> thanks,
> jirka
>
> Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>

I commented on the patch 5/5, anyway looks good to me:

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung

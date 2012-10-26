Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332Ab2JZB3M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 21:29:12 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:53211 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589Ab2JZB3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 21:29:11 -0400
X-AuditID: 9c930179-b7c8bae000003559-5f-5089e7654f11
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
Date: Fri, 26 Oct 2012 10:29:09 +0900
In-Reply-To: <1350743599-4805-1-git-send-email-jolsa@redhat.com> (Jiri Olsa's
	message of "Sat, 20 Oct 2012 16:33:08 +0200")
Message-ID: <87txti81i2.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Sat, 20 Oct 2012 16:33:08 +0200, Jiri Olsa wrote:
> hi,
> adding support to read sample values through the PERF_SAMPLE_READ
> sample type. It's now possible to specify 'S' modifier for an event
> and get its sample value by PERF_SAMPLE_READ.

I have a question.  What's an actual impact of specifying 'S' modifiere
to a non-group event or even only a (non-leader) member of a group?  For
instance, 'cycles:S' or '{branches,branch-misses:S}'.

Thanks,
Namhyung

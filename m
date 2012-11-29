Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215Ab2K2Lzt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 06:55:49 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:63991 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894Ab2K2Lzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 06:55:48 -0500
X-AuditID: 9c930179-b7c9dae000000e53-d8-50b74d439e4d
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 10/14] perf tool: Centralize default columns init in perf_hpp__init
References: <1354110769-2998-1-git-send-email-jolsa@redhat.com>
	<1354110769-2998-11-git-send-email-jolsa@redhat.com>
Date: Thu, 29 Nov 2012 20:55:47 +0900
In-Reply-To: <1354110769-2998-11-git-send-email-jolsa@redhat.com> (Jiri Olsa's
	message of "Wed, 28 Nov 2012 14:52:45 +0100")
Message-ID: <87ehjcoc70.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Nov 2012 14:52:45 +0100, Jiri Olsa wrote:
> Now when diff command is separated from other standard outputs,
> we can use perf_hpp__init to initialize all standard columns.
>
> Moving PERF_HPP__OVERHEAD column init back to perf_hpp__init,
> and removing extra enable calls.

Why was this needed in the first place?  AFAIK it's already there and
didn't used only for perf diff.

Thanks,
Namhyung

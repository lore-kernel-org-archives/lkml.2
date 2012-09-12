Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079Ab2ILAoq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 20:44:46 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:57378 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755579Ab2ILAoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 20:44:39 -0400
X-AuditID: 9c930197-b7b93ae0000028a7-d2-504fdaf32fb9
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 02/18] perf sched: Remove die() calls
References: <1347407590-30960-1-git-send-email-acme@infradead.org>
	<1347407590-30960-3-git-send-email-acme@infradead.org>
Date: Wed, 12 Sep 2012 09:37:43 +0900
In-Reply-To: <1347407590-30960-3-git-send-email-acme@infradead.org> (Arnaldo
	Carvalho de Melo's message of "Tue, 11 Sep 2012 20:52:54 -0300")
Message-ID: <871ui8axew.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Sep 2012 20:52:54 -0300, Arnaldo Carvalho de Melo wrote:
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
>
> Just use pr_err() + return -1 and perf_session__process_events to abort
> when some event would call die(), then let the perf's main() exit doing
> whatever it needs.

It looks this patch has a same problem as patch 1/18.

Thanks,
Namhyung

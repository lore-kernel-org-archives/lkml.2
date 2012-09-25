Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581Ab2IYEje (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 00:39:34 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:59875 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785Ab2IYEjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 00:39:33 -0400
X-AuditID: 9c930179-b7bfcae0000020b4-af-506135832d2f
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 29/30] perf test: Add test for the sched tracepoint format fields
References: <1348502384-14442-1-git-send-email-acme@infradead.org>
	<1348502384-14442-30-git-send-email-acme@infradead.org>
Date: Tue, 25 Sep 2012 13:31:09 +0900
In-Reply-To: <1348502384-14442-30-git-send-email-acme@infradead.org> (Arnaldo
	Carvalho de Melo's message of "Mon, 24 Sep 2012 12:59:43 -0300")
Message-ID: <87zk4ewwoi.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Sep 2012 12:59:43 -0300, Arnaldo Carvalho de Melo wrote:
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
>
> So that we make sure the routines that do event format parsing are
> working on at least two well know scheduler tracepoints.

It caused a build error and I posted a fix, please see:

https://lkml.org/lkml/2012/9/24/689

Thanks,
Namhyung

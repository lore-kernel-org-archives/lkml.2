Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759566Ab2ILC2U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 22:28:20 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:58634 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758270Ab2ILC2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 22:28:02 -0400
X-AuditID: 9c930197-b7b93ae0000028a7-26-504ff32f16f1
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 16/18] perf evsel: Introduce perf_evsel__{str,int}val methods
References: <1347407590-30960-1-git-send-email-acme@infradead.org>
	<1347407590-30960-17-git-send-email-acme@infradead.org>
Date: Wed, 12 Sep 2012 11:21:07 +0900
In-Reply-To: <1347407590-30960-17-git-send-email-acme@infradead.org> (Arnaldo
	Carvalho de Melo's message of "Tue, 11 Sep 2012 20:53:08 -0300")
Message-ID: <87k3w09e24.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Sep 2012 20:53:08 -0300, Arnaldo Carvalho de Melo wrote:
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
>
> Wrappers to the libtraceevent routines, so that we can further reduce
> the surface contact perf builtins have with it.

I just realized that this breaks the python extension:

namhyung@sejong:perf$ python/twatch.py 
Traceback (most recent call last):
  File "python/twatch.py", line 16, in <module>
    import perf
ImportError: /home/namhyung/project/linux/tools/perf/python/perf.so: undefined symbol: pevent_find_field


Thanks,
Namhyung

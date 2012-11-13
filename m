Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525Ab2KMSSs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 13:18:48 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:37499 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566Ab2KMSSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 13:18:47 -0500
Date: Tue, 13 Nov 2012 19:18:41 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Feng Tang <feng.tang@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Irina Tirdea <irina.tirdea@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 00/32] perf/core improvements and fixes
Message-ID: <20121113181841.GE12824@gmail.com>
References: <1352135893-7564-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352135893-7564-1-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> Jiri Olsa (28):
>       perf tools: Remove BINDIR define from exec_cmd.o compilation
>       perf tests: Move test objects into 'tests' directory
>       perf tests: Add framework for automated perf_event_attr tests
>       perf tests: Add attr record basic test
>       perf tests: Add attr tests under builtin test command
>       perf tests: Add attr record group test
>       perf tests: Add attr record event syntax group test
>       perf tests: Add attr record freq test
>       perf tests: Add attr record count test
>       perf tests: Add attr record graph test
>       perf tests: Add attr record period test
>       perf tests: Add attr record no samples test
>       perf tests: Add attr record no-inherit test
>       perf tests: Add attr record data test
>       perf tests: Add attr record raw test
>       perf tests: Add attr record no delay test
>       perf tests: Add attr record branch any test
>       perf tests: Add attr record branch filter tests
>       perf tests: Add attr stat no-inherit test
>       perf tests: Add attr stat group test
>       perf tests: Add attr stat event syntax group test
>       perf tests: Add attr stat default test
>       perf tests: Add attr stat default test
>       perf tests: Add documentation for attr tests
>       perf tests: Add missing attr stat basic test
>       perf tests: Factor attr tests WRITE_ASS macro
>       perf tests: Fix attr watermark field name typo
>       perf tests: Removing 'optional' field

These testcases are really nice!

	Ingo

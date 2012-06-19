Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751822Ab2FSIFt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 04:05:49 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:61491 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756Ab2FSIFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 04:05:46 -0400
X-AuditID: 9c930197-b7b87ae000000e4d-d5-4fe032d339de
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH v2 1/5] tools lib traceevent: Replace malloc_or_die to plain calloc in alloc_event()
References: <1339987851-22491-1-git-send-email-namhyung@kernel.org>
	<1340027148.25903.90.camel@gandalf.stny.rr.com>
	<20120618140625.GH2303@infradead.org>
Date: Tue, 19 Jun 2012 17:02:16 +0900
In-Reply-To: <20120618140625.GH2303@infradead.org> (Arnaldo Carvalho de Melo's
	message of "Mon, 18 Jun 2012 11:06:25 -0300")
Message-ID: <87r4tbhgqf.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Arnaldo

On Mon, 18 Jun 2012 11:06:25 -0300, Arnaldo Carvalho de Melo wrote:
> Em Mon, Jun 18, 2012 at 09:45:48AM -0400, Steven Rostedt escreveu:
>> Arnaldo,
>> 
>> I've acked this series. Can you add my Acked-by tags on the patches that
>> do not have it yet, and then pull it into your repo?
>
> Sure thing, I'll put it in my perf/core branch,
>

As I said before [1], those patches are based on my libtraceevent/next
branch which contains a couple of commits not merged into tip or your
tree. They are my previous backport work, and Steve wanted to leave them
out for 3.6 cycle [2].

So my question is that do you want to pull those bits too? If so, I can
send a pull request to you if you want. :) - I noticed that your
perf/core branch isn't on top of current tip/perf/core. So I've also
setup libtraceevent/core branch to track your branch.

Thanks,
Namhyung


[1] article.gmane.org/gmane.linux.kernel/1310798
[2] article.gmane.org/gmane.linux.kernel/1302643

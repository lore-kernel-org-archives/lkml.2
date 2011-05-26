Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758166Ab1EZTSl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 15:18:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41538 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751992Ab1EZTSk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 15:18:40 -0400
Date: Thu, 26 May 2011 21:17:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>,
        David Miller <davem@davemloft.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Kees Cook <kees.cook@canonical.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [GIT PULL 0/2] perf/urgent fixes
Message-ID: <20110526191721.GD3476@elte.hu>
References: <1306433134-31869-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306433134-31869-1-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> Hi Ingo,
> 
>         Please consider pulling from:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/urgent
> 
> Regards,
> 
> - Arnaldo
> 
> Arnaldo Carvalho de Melo (2):
>   perf symbols: Handle /proc/sys/kernel/kptr_restrict
>   perf tools: Fix build on older systems
> 
>  tools/perf/Makefile                   |    2 +
>  tools/perf/builtin-record.c           |   13 +++++++++
>  tools/perf/builtin-report.c           |   26 ++++++++++++++++++
>  tools/perf/util/event.c               |   15 ++++++++--
>  tools/perf/util/header.c              |    8 ++++-
>  tools/perf/util/include/linux/const.h |    1 +
>  tools/perf/util/symbol.c              |   48 +++++++++++++++++++++++++++++++++
>  tools/perf/util/symbol.h              |    3 +-
>  8 files changed, 110 insertions(+), 6 deletions(-)
>  create mode 100644 tools/perf/util/include/linux/const.h

Pulled, thanks a lot Arnaldo!

	Ingo

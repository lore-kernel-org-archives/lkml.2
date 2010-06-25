Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756417Ab0FYORh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 10:17:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41177 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754799Ab0FYORg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 10:17:36 -0400
Date: Fri, 25 Jun 2010 16:17:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Stephane Eranian <eranian@google.com>, Tom Zanussi <tzanussi@gmail.com>,
       Yanmin Zhang <yanmin_zhang@linux.intel.com>
Subject: Re: [GIT PULL 0/6] perf/core improvements and fixes for 2.6.36
Message-ID: <20100625141716.GA10283@elte.hu>
References: <1277474366-7958-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277474366-7958-1-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0004]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> Hi Ingo,
> 
>         Please pull from:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/core
> 
> Regards,
> 
> - Arnaldo
> 
> Arnaldo Carvalho de Melo (4):
>   perf ui: Introduce routine ui_browser__is_current_entry
>   perf ui: Introduce ui_browser->seek to support multiple list structures
>   perf ui: Separate showing the entries from running the browser
>   perf ui: Move objdump_line specific stuff out of ui_browser
> 
> Gui Jianfeng (1):
>   perf kvm: Get rid of unused guest_kallsyms
> 
> Tom Zanussi (1):
>   perf scripts perl: Makefile fix
> 
>  tools/perf/Makefile         |    2 +-
>  tools/perf/builtin-record.c |    9 --
>  tools/perf/util/newt.c      |  185 +++++++++++++++++++++++++------------------
>  3 files changed, 109 insertions(+), 87 deletions(-)

Pulled, thanks a lot Arnaldo!

	Ingo

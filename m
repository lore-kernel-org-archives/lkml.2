Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665Ab2ADN40 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 08:56:26 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54433 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755036Ab2ADN4X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 08:56:23 -0500
Date: Wed, 4 Jan 2012 14:54:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Gleb Natapov <gleb@redhat.com>, Joerg Roedel <joerg.roedel@amd.com>,
        kvm@vger.kernel.org, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, arnaldo.melo@gmail.com
Subject: Re: [GIT PULL 0/5] perf/core fixes and improvements
Message-ID: <20120104135418.GB7754@elte.hu>
References: <1325621784-10683-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325621784-10683-1-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
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
> git://github.com/acmel/linux.git perf/core
> 
> Regards,
> 
> - Arnaldo
> 
> Joerg Roedel (1):
>   perf kvm: Fix copy & paste error in description
> 
> Namhyung Kim (4):
>   perf session: Remove impossible condition check
>   perf stat: Introduce get_ratio_color() helper
>   perf top: Fix a memory leak
>   perf script: Kill script_spec__delete
> 
>  tools/perf/builtin-kvm.c    |    2 +-
>  tools/perf/builtin-script.c |   13 +------
>  tools/perf/builtin-stat.c   |   91 ++++++++++++++++--------------------------
>  tools/perf/builtin-top.c    |    1 -
>  tools/perf/util/session.c   |    3 +-
>  5 files changed, 38 insertions(+), 72 deletions(-)

Pulled, thanks a lot Arnaldo!

	Ingo

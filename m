Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335Ab1CQIMV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 04:12:21 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53269 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851Ab1CQIMT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 04:12:19 -0400
Date: Thu, 17 Mar 2011 09:11:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org,
        Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
        Josh Hunt <johunt@akamai.com>,
        Marcin Slusarz <marcin.slusarz@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, stable@kernel.org,
        Tapan Dhimant <tdhimant@akamai.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH 0/2] perf/urgent fixes
Message-ID: <20110317081134.GB26190@elte.hu>
References: <1300304899-21920-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300304899-21920-1-git-send-email-acme@infradead.org>
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
> Josh Hunt (1):
>   perf tools: Version incorrect with some versions of grep
> 
> Marcin Slusarz (1):
>   perf lock: Fix sorting by wait_min
> 
>  tools/perf/builtin-lock.c        |   13 ++++++++++++-
>  tools/perf/util/PERF-VERSION-GEN |    8 ++++----
>  2 files changed, 16 insertions(+), 5 deletions(-)

Pulled, thanks Arnaldo!

	Ingo

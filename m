Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032Ab1C2HMW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 03:12:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58992 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751393Ab1C2HMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 03:12:21 -0400
Date: Tue, 29 Mar 2011 09:12:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@mit.edu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [GIT PULL 0/1] perf/urgent fix
Message-ID: <20110329071210.GG27398@elte.hu>
References: <1301335671-22897-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301335671-22897-1-git-send-email-acme@infradead.org>
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
> 	I need to go over symbol.c to clean up the way the long name
> is set/freed, but Andrew's solves a real problem and thus I think it
> should go in now.
> 
> Regards,
> 
> - Arnaldo
> 
> Andrew Lutomirski (1):
>   perf symbols: Fix vsyscall symbol lookup
> 
>  tools/perf/util/event.c  |    2 +-
>  tools/perf/util/symbol.c |    3 +++
>  2 files changed, 4 insertions(+), 1 deletions(-)

Pulled, thanks Arnaldo!

	Ingo

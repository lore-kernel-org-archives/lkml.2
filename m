Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776Ab0DDJ6o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Apr 2010 05:58:44 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38572 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752469Ab0DDJ6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Apr 2010 05:58:38 -0400
Date: Sun, 4 Apr 2010 11:58:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH 0/2] perf newt: Zoom operations
Message-ID: <20100404095827.GA30536@elte.hu>
References: <1270345250-4833-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1270345250-4833-1-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> Hi Ingo,
> 
>         Please consider pulling from the "perf" branch in:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6
> 
> Best Regards,
> 
> Arnaldo Carvalho de Melo (2):
>   perf newt: Add a "Zoom into foo.so DSO" and reverse operations
>   perf TUI: Add a "Zoom into COMM(PID) thread" and reverse operations
> 
>  tools/perf/util/newt.c |  185 ++++++++++++++++++++++++++++++++++++++++--------
>  tools/perf/util/sort.h |   10 ++-
>  2 files changed, 162 insertions(+), 33 deletions(-)

Pulled, thanks Arnaldo!

There's still a few basic usability glitches that i've noticed:

 - it's not clear how to zoom out, once zoomed in

 - there's no help screen and no help line for people to see what can be 
   done on a given screen. While it's good that the intuitive things work
   by default (arrow keys, escape, enter, etc.), there should also be additional
   visual information about what can be done.

 - i think double escape should exit, right now it stays at the 'are you sure'
   screen

	Ingo

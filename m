Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761304Ab0J2K6H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 06:58:07 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37562 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757167Ab0J2K6F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 06:58:05 -0400
Date: Fri, 29 Oct 2010 12:57:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oprofile-list@lists.sourceforge.net" 
	<oprofile-list@lists.sourceforge.net>
Subject: Re: [GIT PULL] oprofile fixes for v2.6.37
Message-ID: <20101029105758.GA20055@elte.hu>
References: <20101029100420.GF5969@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101029100420.GF5969@erda.amd.com>
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


* Robert Richter <robert.richter@amd.com> wrote:

> Ingo,
> 
> please pull oprofile fixes v2.6.37:
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git urgent
> 
> Thanks,
> 
> -Robert
> 
> 
> The following changes since commit e25804a0327dad954f7d43803178fdef2fd35b4e:
> 
>   Merge branch 'perf/core' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 into perf/urgent (2010-10-27 08:25:15 +0200)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git for-next
> 
> Santosh Shilimkar (1):
>       oprofile: Fix the hang while taking the cpu offline
> 
> Tejun Heo (1):
>       oprofile: Remove deprecated use of flush_scheduled_work()
> 
>  drivers/oprofile/buffer_sync.c |    2 +-
>  drivers/oprofile/cpu_buffer.c  |   10 +++++++---
>  drivers/oprofile/cpu_buffer.h  |    1 +
>  drivers/oprofile/timer_int.c   |   13 +++++++++++++
>  4 files changed, 22 insertions(+), 4 deletions(-)

Pulled, thanks Robert!

	Ingo

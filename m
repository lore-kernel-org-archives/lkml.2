Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759149Ab0JYRQm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 13:16:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34023 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101Ab0JYRQl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 13:16:41 -0400
Date: Mon, 25 Oct 2010 19:16:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oprofile-list@lists.sourceforge.net" 
	<oprofile-list@lists.sourceforge.net>
Subject: Re: [GIT PULL] oprofile updates for v2.6.37
Message-ID: <20101025171630.GB1636@elte.hu>
References: <20101025154601.GM5969@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101025154601.GM5969@erda.amd.com>
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
> please consider to pull AMD oprofile cpu updates for tip/perf/core and
> v2.6.37:
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git x86
> 
> Thanks,
> 
> -Robert
> 
> 
> The following changes since commit d4429f608abde89e8bc1e24b43cd503feb95c496:
> 
>   Merge branch 'next' of git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc (2010-10-21 21:19:54 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git for-next
> 
> Robert Richter (10):
>       oprofile, x86: Add support for AMD family 12h
>       oprofile, x86: Add support for AMD family 14h
>       oprofile, x86: Check IBS capability bits 1 and 2
>       oprofile, x86: Remove duplicate check for IBS_CAPS_OPCNT
>       oprofile, x86: Introduce struct ibs_state
>       oprofile, x86: Add support for IBS branch target address reporting
>       oprofile, x86: Add support for IBS periodic op counter extension
>       Merge commit 'v2.6.36' into oprofile/core
>       Merge commit 'linux-2.6/master' (early part) into oprofile/core
>       Merge branch 'oprofile/core' into oprofile/x86
> 
>  arch/x86/include/asm/msr-index.h  |    1 +
>  arch/x86/include/asm/perf_event.h |   19 +++---
>  arch/x86/oprofile/nmi_int.c       |    6 ++
>  arch/x86/oprofile/op_model_amd.c  |  120 +++++++++++++++++++++++++-----------
>  4 files changed, 100 insertions(+), 46 deletions(-)

Pulled, thanks Robert!

	Ingo

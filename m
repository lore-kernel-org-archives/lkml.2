Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555Ab0IAJln (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 05:41:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48058 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751870Ab0IAJlk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 05:41:40 -0400
Date: Wed, 1 Sep 2010 11:41:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        oprofile-list <oprofile-list@lists.sourceforge.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [GIT PULL] oprofile fixes
Message-ID: <20100901094121.GA3606@elte.hu>
References: <20100901084632.GI22783@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100901084632.GI22783@erda.amd.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.5
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0185]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Robert Richter <robert.richter@amd.com> wrote:

> Ingo,
> 
> please pull oprofile fixes from:
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git urgent
> 
> Thanks,
> 
> -Robert
> 
> The following changes since commit da5cabf80e2433131bf0ed8993abc0f7ea618c73:
> 
>   Linux 2.6.36-rc1 (2010-08-15 17:41:37 -0700)
> 
> are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git urgent
> 
> Robert Richter (2):
>       oprofile: fix crash when accessing freed task structs
>       oprofile, x86: fix init_sysfs error handling
> 
>  arch/x86/oprofile/nmi_int.c    |   16 +++++++++++++---
>  drivers/oprofile/buffer_sync.c |   27 ++++++++++++++-------------
>  drivers/oprofile/cpu_buffer.c  |    2 --
>  3 files changed, 27 insertions(+), 18 deletions(-)

Pulled, thanks a lot Robert!

	Ingo

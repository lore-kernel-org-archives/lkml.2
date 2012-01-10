Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598Ab2AJJFe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 04:05:34 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38790 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755436Ab2AJJF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 04:05:29 -0500
Date: Tue, 10 Jan 2012 10:05:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Fabio Estevam <festevam@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        a.p.zijlstra@chello.nl, Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH] init/Kconfig: Fix dependency for SCHED_AUTOGROUP
Message-ID: <20120110090521.GB5405@elte.hu>
References: <1326157288-4407-1-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326157288-4407-1-git-send-email-festevam@gmail.com>
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


* Fabio Estevam <festevam@gmail.com> wrote:

> Fix the following build warning:
> 
> warning: (SCHED_AUTOGROUP) selects CGROUP_SCHED which has unmet direct dependencies (CGROUPS && EXPERIMENTAL)
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> ---
>  init/Kconfig |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/init/Kconfig b/init/Kconfig
> index 34f6d0c..b5cae89 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -850,6 +850,7 @@ endif # NAMESPACES
>  
>  config SCHED_AUTOGROUP
>  	bool "Automatic process group scheduling"
> +	depends on EXPERIMENTAL
>  	select EVENTFD
>  	select CGROUPS
>  	select CGROUP_SCHED

I think this should rather be solved by removing the 
EXPERIMENTAL dependency from CGORUP_SCHED.

Thanks,

	Ingo

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751284Ab1ADKmR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 05:42:17 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47543 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779Ab1ADKmQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 05:42:16 -0500
Date: Tue, 4 Jan 2011 11:42:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: jean.pihet@newoldbits.com
Cc: linux-kernel@vger.kernel.org, trenn@suse.de, linux-omap@vger.kernel.org,
        Arjan van de Ven <arjan@linux.intel.com>,
        linux-perf-users@vger.kernel.org, rjw@sisk.pl,
        Jean Pihet <j-pihet@ti.com>
Subject: Re: [PATCH 2/3] perf: add OMAP support for the new power events
Message-ID: <20110104104203.GB2447@elte.hu>
References: <1294136263-24020-1-git-send-email-j-pihet@ti.com>
 <1294136263-24020-3-git-send-email-j-pihet@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294136263-24020-3-git-send-email-j-pihet@ti.com>
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


* jean.pihet@newoldbits.com <jean.pihet@newoldbits.com> wrote:

> From: Jean Pihet <j-pihet@ti.com>
> 
> The patch adds the new power management trace points for
> the OMAP architecture.
> 
> The trace points are for:
> - default idle handler. Since the cpuidle framework is
>   instrumented in the generic way there is no need to
>   add trace points in the OMAP specific cpuidle handler;
> - cpufreq (DVFS),
> - clocks changes (enable, disable, set_rate),
> - change of power domains next power states.
> 
> Signed-off-by: Jean Pihet <j-pihet@ti.com>
> ---
>  arch/arm/mach-omap2/pm34xx.c      |    7 +++++++
>  arch/arm/mach-omap2/powerdomain.c |    3 +++
>  arch/arm/plat-omap/clock.c        |   13 ++++++++++---
>  3 files changed, 20 insertions(+), 3 deletions(-)

I suspect the gents and mailing lists listed by:

  scripts/get_maintainer.pl -f arch/arm/plat-omap/clock.c
  scripts/get_maintainer.pl -f arch/arm/mach-omap2/pm34xx.c

Would want to be Cc:-ed as well. That will also get the right Acked-by's. (if you 
want these commits to go upstream via the perf tree)

Thanks,

	Ingo

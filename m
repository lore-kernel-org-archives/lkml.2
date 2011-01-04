Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751370Ab1ADKkL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 05:40:11 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46767 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917Ab1ADKkK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 05:40:10 -0500
Date: Tue, 4 Jan 2011 11:39:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: jean.pihet@newoldbits.com
Cc: linux-kernel@vger.kernel.org, trenn@suse.de, linux-omap@vger.kernel.org,
        Arjan van de Ven <arjan@linux.intel.com>,
        linux-perf-users@vger.kernel.org, rjw@sisk.pl,
        Jean Pihet <j-pihet@ti.com>
Subject: Re: [PATCH 1/3] perf: add calls to suspend trace point
Message-ID: <20110104103943.GA2447@elte.hu>
References: <1294136263-24020-1-git-send-email-j-pihet@ti.com>
 <1294136263-24020-2-git-send-email-j-pihet@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294136263-24020-2-git-send-email-j-pihet@ti.com>
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
> Uses the machine_suspend trace point, called from the
> generic kernel suspend_enter function.
> 
> Signed-off-by: Jean Pihet <j-pihet@ti.com>
> CC: Thomas Renninger <trenn@suse.de>
> ---
>  kernel/power/suspend.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)

Please use the scripts/get_maintainer.pl to construct a proper Cc: list and to 
gather the necessary Acked-by:

  scripts/get_maintainer.pl -f kernel/power/suspend.c

Thanks,

	Ingo

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756337Ab1LBCJl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 21:09:41 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:61514 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755776Ab1LBCJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 21:09:40 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/b3WQt81VF/7zIrXzPmGfT
Date: Thu, 1 Dec 2011 18:09:37 -0800
From: Tony Lindgren <tony@atomide.com>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: Paul Walmsley <paul@pwsan.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2 v2] ARM: OMAP1: Fix dpll1 reprogramming related
 issues
Message-ID: <20111202020936.GY31337@atomide.com>
References: <201112012023.04635.jkrzyszt@tis.icnet.pl>
 <1322770382-30718-1-git-send-email-jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322770382-30718-1-git-send-email-jkrzyszt@tis.icnet.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Janusz Krzysztofik <jkrzyszt@tis.icnet.pl> [111201 11:38]:
> After dpll1 reprogramming has been moved from setup_arch() to
> kernel_init(), I've been observing several issues, resulting in
> undesired system behaviour on my Amstrad Delta. This series fixes
> those most important (2/5 and 5/5 v2 previously), with a "stuck at 60MHz
> rate" issue going to be fixed with Tony's proposed solution instead of
> my previous 3/5.
> 
> Janusz Krzysztofik (2):
>   ARM: OMAP1: Fix ckctl value used for dpll1 defualt rate
>   ARM: OMAP1: recalculate loops per jiffy after dpll1 reprogram
> 
>  arch/arm/mach-omap1/clock_data.c |    9 +++++++--
>  1 files changed, 7 insertions(+), 2 deletions(-)

Thanks, got these three patches now applied into fixes on top of -rc4.

Can you please try it out to make sure it's all working for you now?

Tony

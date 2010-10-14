Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497Ab0JNQXb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 12:23:31 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43705 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752677Ab0JNQXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 12:23:30 -0400
Date: Thu, 14 Oct 2010 18:23:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Anand Gadiyar <gadiyar@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        paulus <paulus@samba.org>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH] arm: perf: Fix build break due to a typo
Message-ID: <20101014162312.GA24972@elte.hu>
References: <1287066841-28569-1-git-send-email-gadiyar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287066841-28569-1-git-send-email-gadiyar@ti.com>
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


* Anand Gadiyar <gadiyar@ti.com> wrote:

> armpmu is a pointer to a structure - We need to use the structure 
> pointer operator to access num_events, and not the structure member 
> operator.
> 
> This fixes the following build break when building for OMAP4.

Yeah - i already fixed it earlier today and pushed it out.

Thanks,

	Ingo

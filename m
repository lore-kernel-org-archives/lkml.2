Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab1EJG1B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 02:27:01 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52664 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751781Ab1EJG1A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 02:27:00 -0400
Date: Tue, 10 May 2011 08:26:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cliff Wickman <cpw@sgi.com>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: UV BAU fix for non-consecutive nasids
Message-ID: <20110510062653.GA11595@elte.hu>
References: <E1QJWvo-0006ug-Fd@eag09.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1QJWvo-0006ug-Fd@eag09.americas.sgi.com>
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


* Cliff Wickman <cpw@sgi.com> wrote:

> From: Cliff Wickman <cpw@sgi.com>
> 
> This is a fix for the SGI Altix-UV Broadcast Assist Unit code, which is
> used for TLB flushing.
> 
> This patch allows nasids (numa address space id's) to be non-consecutive, as is
> the case when using nasid striding or in some certain hardware configurations.
> It also provides a table in local memory for each cpu to translate target cpu
> number to target pnode and nasid.

This changelog is missing one or more of the following essential pieces
of information:

 - what user-visible problem is the patch solving
 - how was the problem triggered, how was the bug found
 - what/how many systems are affected
 - why should maintainers apply this patch right now

Thanks,

	Ingo

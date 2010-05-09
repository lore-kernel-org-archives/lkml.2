Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752425Ab0EIRuM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 13:50:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37617 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751554Ab0EIRuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 13:50:09 -0400
Date: Sun, 9 May 2010 19:49:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, davej@redhat.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH v2  0/8] Fix performance issue with ondemand governor
Message-ID: <20100509174936.GB17881@elte.hu>
References: <20100509082126.4a080d46@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100509082126.4a080d46@infradead.org>
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


* Arjan van de Ven <arjan@infradead.org> wrote:

> [Version 2 includes the acks/etc. Andrew: no changes from the patches that 
> are in -mm]
> 
> There have been various reports of the ondemand governor causing some 
> serious performance issues, one of the latest ones from Andrew. There are 
> several fundamental issues with ondemand (being worked on), but the report 
> from Andrew can be fixed relatively easily.
> 
> The fundamental issue is that ondemand will go to a (too) low CPU frequency 
> for workloads that alternatingly disk and CPU bound...

I've applied your series to sched/core and started testing it, thanks Arjan!

	Ingo

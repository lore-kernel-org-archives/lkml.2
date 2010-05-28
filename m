Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932095Ab0E1Jau (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 05:30:50 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37633 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757711Ab0E1Jaq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 05:30:46 -0400
Date: Fri, 28 May 2010 11:30:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rik van Riel <riel@redhat.com>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       davej@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH v2  0/8] Fix performance issue with ondemand governor
Message-ID: <20100528093025.GE24058@elte.hu>
References: <20100509082126.4a080d46@infradead.org>
 <20100509174936.GB17881@elte.hu>
 <4BFAE533.6080603@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BFAE533.6080603@redhat.com>
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


* Rik van Riel <riel@redhat.com> wrote:

> On 05/09/2010 01:49 PM, Ingo Molnar wrote:
> >* Arjan van de Ven<arjan@infradead.org>  wrote:
> >
> >>[Version 2 includes the acks/etc. Andrew: no changes from the patches that
> >>are in -mm]
> >>
> >>There have been various reports of the ondemand governor causing some
> >>serious performance issues, one of the latest ones from Andrew. There are
> >>several fundamental issues with ondemand (being worked on), but the report
> >>from Andrew can be fixed relatively easily.
> >>
> >>The fundamental issue is that ondemand will go to a (too) low CPU frequency
> >>for workloads that alternatingly disk and CPU bound...
> >
> >I've applied your series to sched/core and started testing it, thanks Arjan!
> 
> This code seems to help significantly with some workloads,
> allowing more systems to use the ondemand governor (and
> having fewer systems waste power by using the performance
> governor all the time).
> 
> It would be nice to see it in 2.6.35

Yeah, it's uptream now :-)

Cheers,

	Ingo

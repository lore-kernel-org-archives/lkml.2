Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833Ab1EKRaS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 13:30:18 -0400
Received: from fallback.mail.elte.hu ([157.181.151.13]:38814 "EHLO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805Ab1EKRaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 13:30:16 -0400
Date: Wed, 11 May 2011 16:00:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Borislav Petkov <bp@amd64.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] perf: Carve out cgroup-related code
Message-ID: <20110511140031.GA18219@elte.hu>
References: <20110511121135.GA25865@aftab>
 <1305121600.2914.214.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305121600.2914.214.camel@laptop>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Wed, 2011-05-11 at 14:11 +0200, Borislav Petkov wrote:
> >  include/linux/perf_event.h |  138 ++++++++++++-
> 
> I don't like exposing all that in a kernel wide header.. should we maybe
> have kernel/events/internal.h?

Yeah.

We could eventually avoid exposing much of struct perf_event as well: arch PMU 
drivers need the struct perf_event_attr, struct hw_perf_event and not much 
else.

Thanks,

	Ingo

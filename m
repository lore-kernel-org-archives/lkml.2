Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756321Ab1CXQdm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 12:33:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58085 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752786Ab1CXQdk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 12:33:40 -0400
Date: Thu, 24 Mar 2011 17:33:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Lin Ming <ming.m.lin@intel.com>, Don Zickus <dzickus@redhat.com>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] perf, x86: P4 PMU - Add missing read of a counter
 before test
Message-ID: <20110324163332.GA2414@elte.hu>
References: <AANLkTikwJFCrpTit8=-=agowkTwZtoyEtFaE7yp0O8MF@mail.gmail.com>
 <20110324084819.GH30812@elte.hu>
 <4D8B6569.2030001@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D8B6569.2030001@gmail.com>
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


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> On 03/24/2011 11:48 AM, Ingo Molnar wrote:
> > 
> > * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> > 
> >> Don, I've added yours SOB, ok? (The patch is attached to avoid
> >> space/tabs problem
> >> due to web-mail client)
> > 
> > The patch lacks a proper description about the motivation and effects of the 
> > patch.
> > 
> > Thanks,
> > 
> > 	Ingo
> 
> Ingo, does this one looks better?
> 
> ---
> From: Don Zickus <dzickus@redhat.com>
> Subject: [PATCH -tip] perf, x86: P4 PMU - Add missing read of MSR register to catch unflagged overflows
> 
> The read of a proper MSR register was missed so instead of a counter the 
> configration register is tested (it has ARCH_P4_UNFLAGGED_BIT always cleared) 
> and unflagged overflows never have been catched. Fix it by reading a proper 
> MSR register.

So what effect does this have on the regular perf user? Please try to describe 
the real-life effect of the bug/problem fixed here.

Thanks,

	Ingo

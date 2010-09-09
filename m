Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345Ab0IIHyd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 03:54:33 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47728 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751285Ab0IIHy1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 03:54:27 -0400
Date: Thu, 9 Sep 2010 09:54:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jean Pihet <jean.pihet@newoldbits.com>
Cc: Thomas Renninger <trenn@suse.de>, Arjan van de Ven <arjan@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Len Brown <len.brown@intel.com>,
        arjan@infradead.org, Kevin Hilman <khilman@deeprootsystems.com>,
        linux-kernel@vger.kernel.org, discuss@lesswatts.org,
        linux-pm@lists.linux-foundation.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH] tracing, perf: add more power related events
Message-ID: <20100909075403.GA10798@elte.hu>
References: <AANLkTinUmbSUUuxUzc8++pcb9gd1CZFdyTQFrveTBXyV@mail.gmail.com>
 <20100908065333.GG3439@elte.hu>
 <AANLkTikpwSA411XRTi7Ybj_19URnW0mEMrf6pFYNpxVF@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikpwSA411XRTi7Ybj_19URnW0mEMrf6pFYNpxVF@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.5
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0450]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jean Pihet <jean.pihet@newoldbits.com> wrote:

> On Wed, Sep 8, 2010 at 8:53 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Jean Pihet <jean.pihet@newoldbits.com> wrote:
> >
> >> Hi,
> >>
> >> Here is a patch proposal for adding new trace events for power management.
> >> Note: thread restarted after the initial discussions on LKML.
> >
> > Also mind including the ACPI tracepoints we talked about? That way a lot
> > more people could test it, etc.
>
> I think the ACPI tracepoints can be added on top of the proposed 
> patch. Is that ok?

Yeah - and the OMAP thing can be split up too if the OMAP folks prefer 
it that way, but we still want to _see_ all the patches in this thread 
together so that we have a critical mass of people interested in all 
this ...

Thanks,

	Ingo

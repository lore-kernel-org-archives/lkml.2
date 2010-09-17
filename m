Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278Ab0IQPgR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 11:36:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34338 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754836Ab0IQPgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 11:36:16 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] tracing, perf: add more power related events
Date: Fri, 17 Sep 2010 17:36:13 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.31.5-0.1-desktop; KDE/4.4.3; x86_64; ; )
Cc: Jean Pihet <jean.pihet@newoldbits.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Len Brown <len.brown@intel.com>,
        arjan@infradead.org, Kevin Hilman <khilman@deeprootsystems.com>,
        linux-kernel@vger.kernel.org, discuss@lesswatts.org,
        linux-pm@lists.linux-foundation.org, linux-omap@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-trace-users@vger.kernel.org
References: <AANLkTinUmbSUUuxUzc8++pcb9gd1CZFdyTQFrveTBXyV@mail.gmail.com> <AANLkTi=W_Lo2m=hkA2F48oUziqGzt4Tr8y6KhfgqRnbz@mail.gmail.com> <20100917142459.GA28124@elte.hu>
In-Reply-To: <20100917142459.GA28124@elte.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009171736.14170.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 September 2010 16:24:59 Ingo Molnar wrote:
> 
> * Jean Pihet <jean.pihet@newoldbits.com> wrote:
> 
> > > Apropos documentation..., are the power trace events documented
> > > somewhere?
> >
> > No. We need something like Documentation/trace/events-kmem.txt. I
> > can write that with for the new power API.
> Such a patch introducing events-power.txt would be most welcome!
Better wait a bit...
As soon as it exists, things are harder to change.
As long as there isn't an API documented, there doesn't exist one
(yes we want to have perf timechart, etc. still functional/compatible,
but still, better let's do not the same mistake with some quick shots).

Whatabout adding perf/trace interfaces to:
Documentation/ABI/*/perf-xy

    Thomas

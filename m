Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756499Ab0KJPB1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 10:01:27 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38301 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756175Ab0KJPB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 10:01:26 -0500
Date: Wed, 10 Nov 2010 16:00:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Greg KH <gregkh@suse.de>,
        LKML <linux-kernel@vger.kernel.org>, Lin Ming <ming.m.lin@intel.com>,
        Stephane Eranian <eranian@google.com>,
        "robert.richter" <robert.richter@amd.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        fweisbec <fweisbec@gmail.com>, paulus <paulus@samba.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: sysfs: Add an 'events' class. (was: Re: [RFC][PATCH] perf: sysfs
 type id)
Message-ID: <20101110150057.GB14496@elte.hu>
References: <1289339119.2191.92.camel@laptop>
 <20101109221338.GA19947@suse.de>
 <1289392037.2191.105.camel@laptop>
 <20101110133638.GC11388@elte.hu>
 <AANLkTikkV1pdseitAPkXTyK529vsvbaVb-RMiMY4Ao-+@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikkV1pdseitAPkXTyK529vsvbaVb-RMiMY4Ao-+@mail.gmail.com>
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


* Kay Sievers <kay.sievers@vrfy.org> wrote:

> > Same here - calling events a 'bus' is like totally brain-dead IMHO. It implies 
> > something hardware, while many events are not related to any hardware component 
> > but are pure software abstractions: such as context-switches, or syscall 
> > entries, or VM events.
> 
> Please use a bus, regardless of the name, class is dead and you will need stuff 
> tha can only happen at bus. We'll fix the name later.

When is that 'later' supposed to happen? git annotate says that the 
renaming/unification comments/plans were added:

46336009        (Kay Sievers    2007-06-08 13:36:37 -0700       105)  symlinks pointing to the unified /sys/devices tree.

... about 3 and a half years ago.

> [...] No, /sys/devices/ is and stays as a hierarchy and will not be flat.

Great :-)

Btw., where will thinks like /sys/kernel/slab/ end up? It would be useful (in the 
long run) to have:

  /sys/kernel/slab/uid_cache/events/

To describe/control events for the uid_cache SLAB cache alone.

	Ingo

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761298Ab1EARze (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 13:55:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54288 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755062Ab1EARzb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 13:55:31 -0400
Date: Sun, 1 May 2011 19:55:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@linux.intel.com>,
        Pekka Enberg <penberg@kernel.org>,
        Vince Weaver <vweaver1@eecs.utk.edu>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@gmail.com>, Carl Love <carll@us.ibm.com>
Subject: Re: re-enable Nehalem raw Offcore-Events support
Message-ID: <20110501175505.GA27830@elte.hu>
References: <alpine.DEB.2.00.1104291056220.22212@cl320.eecs.utk.edu>
 <BANLkTimjmYUJMGw0aB+w+E76H+kxSpqFZg@mail.gmail.com>
 <20110429172525.GA2745@tassilo.jf.intel.com>
 <alpine.LFD.2.02.1104291938240.3005@ionos>
 <4DBC6BC1.5090102@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DBC6BC1.5090102@linux.vnet.ibm.com>
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


* Corey Ashford <cjashfor@linux.vnet.ibm.com> wrote:

> Carl Love and I recently completed some work to add perf_events support for 
> the IBM Blue Waters machine's "CPU networking" chip, called the Torrent chip.  
> We did all of this work based on a RHEL 6 kernel (2.6.32ish), which doesn't 
> have Peter's more recent multi-PMU support.
> 
> I would say that most if not all of the events are not generalizable in the 
> sense that you are talking about; the events are very specific to the Torrent 
> chip. [...]

That's ok and not a problem.

The issue here are events that *are* generalizable.

> So if I'm understanding what you have said correctly, we would not be able to 
> get a forward port of this code committed without abstracting these events in 
> a away that's acceptable to the kernel community. [...]

If the number of events worth generalizing is the empty set that's ok.

Thanks,

	Ingo

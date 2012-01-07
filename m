Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960Ab2AGMWJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jan 2012 07:22:09 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40135 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751854Ab2AGMWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jan 2012 07:22:07 -0500
Date: Sat, 7 Jan 2012 13:20:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 00/16] [GIT PULL] tracing: fixes/cleanups, no
 stop-machine, update stack tracer
Message-ID: <20120107121959.GA28462@elte.hu>
References: <1325635922.12696.8.camel@gandalf.stny.rr.com>
 <1325653301.12696.20.camel@gandalf.stny.rr.com>
 <20120104141107.GA24770@elte.hu>
 <1325696759.12696.24.camel@gandalf.stny.rr.com>
 <20120105091916.GA22598@elte.hu>
 <1325764011.12696.38.camel@gandalf.stny.rr.com>
 <1325765791.12696.41.camel@gandalf.stny.rr.com>
 <1325825918.12696.64.camel@gandalf.stny.rr.com>
 <20120106085104.GE14188@elte.hu>
 <1325851838.12696.70.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325851838.12696.70.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Fri, 2012-01-06 at 09:51 +0100, Ingo Molnar wrote:
> > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > Not sure what else to do. Have you been able to trigger 
> > > these bugs without my patches? All the bugs I've been 
> > > hitting after merging my patches, I've been able to hit 
> > > with tip/master as well.
> > 
> > No, as i described to you the tree(s) without your patches 
> > all did 50+ series of bootups.
> > 
> 
> Is it only with this config that it fails? Is there another 
> config that doesn't? Also is it only failing on one box, or 
> can you reproduce the failure on different hardware? What 
> version of fedora are you running? Could this be something 
> that requires systemd?

I've now established a 500 successful randconfig tests run 
baseline, and will merge in your trees and see whether they 
start producing failures.

If they don't then i think we can chalk up the allyesconfig 
failures to some other factor.

Thanks,

	Ingo

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756583Ab1BJQic (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 11:38:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21175 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820Ab1BJQia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 11:38:30 -0500
Date: Thu, 10 Feb 2011 14:38:09 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Mike Galbraith <efault@gmx.de>
Cc: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, eranian@google.com,
        linux-kernel@vger.kernel.org, tzanussi@gmail.com, peterz@infradead.org,
        fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu,
        linux-tip-commits@vger.kernel.org
Subject: perf annotate: new TUI features
Message-ID: <20110210163809.GC20676@ghostprotocols.net>
References: <new-submission> <tip-d5e3d747007fdb541e57ed72e020ff0b94db3470@git.kernel.org> <1297224378.8035.7.camel@marge.simson.net> <20110209164154.GA15607@ghostprotocols.net> <1297309313.7996.11.camel@marge.simson.net> <1297309891.7996.13.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297309891.7996.13.camel@marge.simson.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Feb 10, 2011 at 04:51:31AM +0100, Mike Galbraith escreveu:
> On Thu, 2011-02-10 at 04:41 +0100, Mike Galbraith wrote:
> 
> > I like this a lot, great for live rummaging.   One thing that would help
> > with large files maybe - a jump to next spot hotter than N%, but as is
 
> (and callgraphs, and a snapshot logger with notes insertion and and...

Right, when testing the top TUI I keep trying to use the same menu we
have on the report, to filter by DSO or thread (the Zoom/Unzoom
operations in report TUI).

So eventually I want to get that struct sym_entry used by top merged
with hist_entry, used by report, in an efficient fashion, so that we can
merge all these interfaces.

Live callgraphs if one presses enter on a annotate line seems like a
nice thing to have, indeed, exactly as we have statically in the perf
report TUI :)

> boy, tui thingy adds a _lot_ of potential to top:) 

Yeah, and all the work done to have it working on a TUI paves the way
for a GUI, but I want to have the TUI streamlined first, so that the GUI
becomes just a boilerplatish matter :-)

- Arnaldo

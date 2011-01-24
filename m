Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751989Ab1AXW3o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 17:29:44 -0500
Received: from cantor.suse.de ([195.135.220.2]:47626 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751339Ab1AXW3n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 17:29:43 -0500
From: Thomas Renninger <trenn@suse.de>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: Perf ABI versioning
Date: Mon, 24 Jan 2011 23:30:01 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc5-5.99.12.5343e5f-desktop; KDE/4.4.4; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        tardyp@gmail.com, jean.pihet@newoldbits.com,
        linux-perf-users@vger.kernel.org, mathieu.desnoyers@efficios.com,
        linux-trace-users@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
References: <201101241704.01021.trenn@suse.de> <201101242249.14471.trenn@suse.de> <20110124215755.GE6367@ghostprotocols.net>
In-Reply-To: <20110124215755.GE6367@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101242330.03008.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 24 January 2011 22:57:55 Arnaldo Carvalho de Melo wrote:
> Em Mon, Jan 24, 2011 at 10:49:13PM +0100, Thomas Renninger escreveu:
... 
> Using the /format file hashed as peterz said is elegant, fine grained
> content based ABI number :-)
Ok thanks, I should have had a closer look at the binary format.

It may make sense at some time to provide a library so that other tools
can make use of the most convenient functions in tools/perf/utils/*
as well?

I'll have a look at the powertop perf implementations I wanted to
look at anyway and try to understand the stuff a bit better.

Thanks,

       Thomas

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002Ab0L0VjG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 16:39:06 -0500
Received: from gate.crashing.org ([63.228.1.57]:49964 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846Ab0L0VjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 16:39:04 -0500
Subject: Re: [PATCH][GIT PULL] powerpc64/tracing: Add frame buffer to calls
 of trace_hardirqs_on/off
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joerg Sommer <joerg@alea.gnuu.de>,
        linuxppc-dev <linuxppc-dev@ozlabs.org>
In-Reply-To: <1293311043.22802.434.camel@gandalf.stny.rr.com>
References: <1293169566.22802.420.camel@gandalf.stny.rr.com>
	 <1293225065.16694.796.camel@pasglop>
	 <1293311043.22802.434.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Dec 2010 08:38:37 +1100
Message-ID: <1293485917.16694.821.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-12-25 at 16:04 -0500, Steven Rostedt wrote:
> 
> Note, when CONFIG_IRQSOFF_TRACE is set, there's already a bit of
> overhead :-)
> 
> Anyway, I'll have to take a look at how the frame pointer is set up.
> Or
> we could also set up all stacks coming into the kernel to have a
> "dummy"
> frame pointer that wont hurt anything if we index into it.
> 
> Anyway, I'm off till the new year, so I'll worry about it then ;-)

Right, might be simpler to just make them loop back onto themselves or
something like that. I can have a look too if I get a chance.

Cheers,
Ben.


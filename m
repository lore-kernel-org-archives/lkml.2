Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891Ab0E1AoN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 20:44:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:43985 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919Ab0E1AoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 20:44:11 -0400
Date: Thu, 27 May 2010 21:43:28 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL, v2] perf changes
Message-ID: <20100528004328.GD6422@ghostprotocols.net>
References: <20100524192531.GA15614@elte.hu> <20100525002221.GA30395@drongo> <20100525135200.GA21462@elte.hu> <alpine.LFD.2.00.1005271533010.11382@i5.linux-foundation.org> <1275006757.22648.567.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275006757.22648.567.camel@gandalf.stny.rr.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, May 27, 2010 at 08:32:37PM -0400, Steven Rostedt escreveu:
> On Thu, 2010-05-27 at 15:34 -0700, Linus Torvalds wrote:
> 
> > The actual kernel still grew:
> > 
> >  32 files changed, 1327 insertions(+), 964 deletions(-)
> 
> Well, if it's any consolation, that patch pull did include my 100K
> reduction in trace events.

Bah, these investors, who would believe in them? :-P

- Arnaldo

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701Ab0ESITX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 04:19:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:46796 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177Ab0ESITU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 04:19:20 -0400
Subject: Re: [tip:perf/core] perf/ftrace: Optimize perf/tracepoint
 interaction for single events
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, efault@gmx.de, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org
In-Reply-To: <20100519075804.GF5704@nowhere>
References: <tip-4f41c013f553957765902fb01475972f0af3e8e7@git.kernel.org>
	 <20100519075804.GF5704@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 19 May 2010 10:18:43 +0200
Message-ID: <1274257123.5605.10260.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-19 at 09:58 +0200, Frederic Weisbecker wrote:
> On Tue, May 18, 2010 at 05:15:42PM +0000, tip-bot for Peter Zijlstra wrote:
> > Commit-ID:  4f41c013f553957765902fb01475972f0af3e8e7
> > Gitweb:     http://git.kernel.org/tip/4f41c013f553957765902fb01475972f0af3e8e7
> > Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
> > AuthorDate: Tue, 18 May 2010 18:08:32 +0200
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Tue, 18 May 2010 18:35:46 +0200
> > 
> > perf/ftrace: Optimize perf/tracepoint interaction for single events
> > 
> > When we've got but a single event per tracepoint
> > there is no reason to try and multiplex it so don't.
> > 

> I haven't seen this patch going.
> 
> But yeah that's a nice optimization for UP machines.

Uhm, doesn't have anything to do with UP machines... it works quite well
on SMP as well.

Its about tracepoints with a single event attached.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632Ab0DWIEU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 04:04:20 -0400
Received: from mail.windriver.com ([147.11.1.11]:48372 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756424Ab0DWIEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 04:04:13 -0400
Date: Fri, 23 Apr 2010 16:03:35 +0800
From: Yong Zhang <yong.zhang@windriver.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: John Kacur <jkacur@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>,
       Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
       Clark Williams <williams@redhat.com>,
       "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: [PATCH] lockdep: Add nr_save_trace_invocations counter
Message-ID: <20100423080335.GC21328@windriver.com>
Reply-To: Yong Zhang <yong.zhang@windriver.com>
References: <alpine.LFD.2.00.1004222208310.3155@localhost>
 <20100423025850.GA21328@windriver.com>
 <1272005525.1646.23.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1272005525.1646.23.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 23 Apr 2010 08:03:37.0138 (UTC) FILETIME=[7A41E120:01CAE2BB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 23, 2010 at 08:52:05AM +0200, Peter Zijlstra wrote:
> On Fri, 2010-04-23 at 10:58 +0800, Yong Zhang wrote:
> > 
> > > +unsigned long nr_save_trace_invocations_type[LOCK_USAGE_STATES];
> > 
> > And each item in this array will equal to nr_hardirq_[un]safe,
> > nr_softirq_[un]safe and such things under lockdep_stats_show(). Right?
> 
> Well, the stats for RECLAIM_FS as missing, so at the very least we need
> to re-write lockdep_stats_show() to use the lockdep_states.h magic.

Yeah, it's a good start point and will keep thing unifying in the future.

Thanks,
Yong

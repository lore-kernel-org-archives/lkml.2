Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102Ab0DWGwL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 02:52:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:60757 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756049Ab0DWGwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 02:52:09 -0400
Subject: Re: [PATCH] lockdep: Add nr_save_trace_invocations counter
From: Peter Zijlstra <peterz@infradead.org>
To: Yong Zhang <yong.zhang@windriver.com>
Cc: John Kacur <jkacur@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>,
       Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
       Clark Williams <williams@redhat.com>,
       "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>
In-Reply-To: <20100423025850.GA21328@windriver.com>
References: <alpine.LFD.2.00.1004222208310.3155@localhost>
	 <20100423025850.GA21328@windriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Apr 2010 08:52:05 +0200
Message-ID: <1272005525.1646.23.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-04-23 at 10:58 +0800, Yong Zhang wrote:
> 
> > +unsigned long nr_save_trace_invocations_type[LOCK_USAGE_STATES];
> 
> And each item in this array will equal to nr_hardirq_[un]safe,
> nr_softirq_[un]safe and such things under lockdep_stats_show(). Right?

Well, the stats for RECLAIM_FS as missing, so at the very least we need
to re-write lockdep_stats_show() to use the lockdep_states.h magic.




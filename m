Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932213Ab2HFUlg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 16:41:36 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53324 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932149Ab2HFUlf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 16:41:35 -0400
Message-ID: <1344285688.27828.114.camel@twins>
Subject: Re: [patch] sched,cgroup_sched: fix up task_groups list
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mike Galbraith <efault@gmx.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Mon, 06 Aug 2012 22:41:28 +0200
In-Reply-To: <1344283776.6768.10.camel@marge.simpson.net>
References: <1344267125.6853.33.camel@marge.simpson.net>
	 <1344279897.27828.97.camel@twins>
	 <1344283776.6768.10.camel@marge.simpson.net>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-08-06 at 22:09 +0200, Mike Galbraith wrote:
> On Mon, 2012-08-06 at 21:04 +0200, Peter Zijlstra wrote: 
> > On Mon, 2012-08-06 at 17:32 +0200, Mike Galbraith wrote:
> > > Thinko happened during sched migration to kernel/sched, fix it up.
> > 
> > what's the effect.. that is what broke and why are we backporting this
> > to -stable?
> 
> The effect is that for_each_rt_rq() doesn't work, because it's not the
> same task_groups list that groups were added to, it's an empty list, so
> __enable/disable_runtime() and print_rt_stats() don't work, and you
> can't see rt task groups.

It seems to me this makes for excellent changelog material ;-)

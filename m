Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528Ab1G2IVY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 04:21:24 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35684 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755046Ab1G2IVS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 04:21:18 -0400
Subject: Re: [PATCH] sched: Remove WAKEUP_PREEMPT feature check in
 entity_tick
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Lin Ming <ming.m.lin@intel.com>, "mingo@elte.hu" <mingo@elte.hu>,
        lkml <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>
In-Reply-To: <20110729081800.GA12106@zhy>
References: <1311846203.3938.1555.camel@minggr.sh.intel.com>
	 <20110729062158.GA8971@zhy>
	 <1311922180.3938.1573.camel@minggr.sh.intel.com>
	 <20110729070356.GA10420@zhy>
	 <1311924975.3938.1583.camel@minggr.sh.intel.com>
	 <20110729074635.GB10420@zhy> <1311926218.5890.215.camel@twins>
	 <20110729081800.GA12106@zhy>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 29 Jul 2011 10:20:50 +0200
Message-ID: <1311927650.5890.217.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-29 at 16:18 +0800, Yong Zhang wrote:
> > Nah, if there is 1 runnable task it will always run, preemption simply
> > doesn't matter. There's nothing to preempt it with.
> 
> Hmmm, so the newly waked task could be scheduled a little later.
> That means schedule tick judge everything. 

Oh, are you referring to the case where a task gets woken on an idle
remote cpu?

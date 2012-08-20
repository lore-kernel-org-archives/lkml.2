Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652Ab2HTGbV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 02:31:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:46579 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754004Ab2HTGbT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 02:31:19 -0400
Message-ID: <1345444270.29668.65.camel@twins>
Subject: Re: [PATCH] sched: fix kernel-doc warnings in kernel/sched/fair.c
From: Peter Zijlstra <peterz@infradead.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>
Date: Mon, 20 Aug 2012 08:31:10 +0200
In-Reply-To: <50303714.3090204@xenotime.net>
References: <50303714.3090204@xenotime.net>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-08-18 at 17:45 -0700, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@xenotime.net>
> 
> Fix kernel-doc warnings in kernel/sched/fair.c:
> 
> Warning(kernel/sched/fair.c:3660): Excess function parameter 'cpus' description in 'update_sg_lb_stats'
> Warning(kernel/sched/fair.c:3806): Excess function parameter 'cpus' description in 'update_sd_lb_stats'

Thanks!

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154Ab2JUQPZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 12:15:25 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:46434 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397Ab2JUQPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 12:15:24 -0400
Date: Sun, 21 Oct 2012 18:15:19 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [GIT PULL] tick: Some consolidation cleanups
Message-ID: <20121021161519.GB27429@gmail.com>
References: <1350320354-17214-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350320354-17214-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Ingo, Thomas,
> 
> I guess those patches are not controversial so I'm joining a
> pull request on the first take, just in case.
> 
> This can be pulled from:
> 
> git://github.com/fweisbec/linux-dynticks.git
> 	nohz/core
> 
> Thanks.
> 
> Frederic Weisbecker (3):
>   tick: Consolidate timekeeping handling code
>   tick: Consolidate tick handling for high and low res handlers
>   tick: Conditionally build nohz specific code in tick handler
> 
>  kernel/time/tick-sched.c |  111 ++++++++++++++++++++--------------------------
>  1 files changed, 48 insertions(+), 63 deletions(-)

Pulled, thanks Frederic!

	Ingo

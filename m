Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758809Ab0IHNZR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 09:25:17 -0400
Received: from one.firstfloor.org ([213.235.205.2]:40316 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756709Ab0IHNZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 09:25:14 -0400
From: Andi Kleen <andi@firstfloor.org>
To: Jan Blunck <jblunck@suse.de>
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
        linux-rt-users@vger.kernel.org, peterz@infradead.org,
        Sven-Thorsten Dietrich <sdietrich@novell.com>,
        Michael Galbraith <MGalbraith@novell.com>
Subject: Re: [RFC 3/4] Disable scheduler tick when we are running SCHED_FIFO tasks
References: <1283948964-6418-1-git-send-email-jblunck@suse.de>
	<1283948964-6418-4-git-send-email-jblunck@suse.de>
Date: Wed, 08 Sep 2010 15:25:13 +0200
In-Reply-To: <1283948964-6418-4-git-send-email-jblunck@suse.de> (Jan Blunck's
	message of "Wed, 8 Sep 2010 14:29:23 +0200")
Message-ID: <87vd6gweo6.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Blunck <jblunck@suse.de> writes:

> This patch is disabling the scheduler tick to go off when there is a task
> with SCHED_FIFO policy running. Since these tasks are not timesliced anyway
> we only care about timers, softirqs and such stuff just like when we disable
> the tick during idle periods.

How would these tasks accounted for then? 

The CPU time accounting relies on the timer tick currently.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

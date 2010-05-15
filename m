Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946Ab0EORcR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 13:32:17 -0400
Received: from cantor.suse.de ([195.135.220.2]:34858 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751882Ab0EORcP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 13:32:15 -0400
Subject: Re: commit e9e9250b: sync wakeup bustage when waker is an RT task
From: Mike Galbraith <mgalbraith@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1273943222.8752.7.camel@marge.simson.net>
References: <1273924628.10630.24.camel@marge.simson.net>
	 <1273925052.1674.138.camel@laptop>
	 <1273943222.8752.7.camel@marge.simson.net>
Content-Type: text/plain
Date: Sat, 15 May 2010 19:32:12 +0200
Message-Id: <1273944732.7807.6.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-05-15 at 19:07 +0200, Mike Galbraith wrote:
> On Sat, 2010-05-15 at 14:04 +0200, Peter Zijlstra wrote:

> > So basically make all RT wakeups sync?
> 
> I was going to just skip subtracting waker's weight ala
> 
>         /*
>          * If sync wakeup then subtract the (maximum possible)
>          * effect of the currently running task from the load
>          * of the current CPU:
>          */
> 	if (sync && !task_has_rt_policy(curr))
> 		...

(not.  hohum, something to piddle with over java manana)


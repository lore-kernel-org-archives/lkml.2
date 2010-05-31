Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154Ab0EaSDf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 14:03:35 -0400
Received: from mail.gmx.net ([213.165.64.20]:34616 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751317Ab0EaSDe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 14:03:34 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+L9FNw+ZeLXGpkZHdf+LrhMMoqkwP/wUV5yta/RE
	9G3gelbupK9d7I
Subject: Re: commit e9e9250b: sync wakeup bustage when waker is an RT task
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1275316109.27810.22969.camel@twins>
References: <1273924628.10630.24.camel@marge.simson.net>
	 <1273925052.1674.138.camel@laptop>
	 <1273943222.8752.7.camel@marge.simson.net>
	 <1273994510.7873.10.camel@marge.simson.net>
	 <1275306978.27810.22357.camel@twins>
	 <1275314209.17599.7.camel@marge.simson.net>
	 <1275316109.27810.22969.camel@twins>
Content-Type: text/plain
Date: Mon, 31 May 2010 20:03:28 +0200
Message-Id: <1275329008.8096.104.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-31 at 16:28 +0200, Peter Zijlstra wrote:
> On Mon, 2010-05-31 at 15:56 +0200, Mike Galbraith wrote:
>  
> > > Does the below work?
> > 
> > Had to make a dinky adjustment for x86-tip-rt33, but yeah, the horrid
> > latencies are gone.  (hm, skinnier than expected too)
> 
> 
> Here's one that should be even skinnier ;-)

Cool, box is into skeletal.

> I knew I already had an accessor: power_of(), also, I duplicated the
> cpu_power variable inside struct rq so we don't have to chase three
> pointers to get it.

Looks good, but I'll retest anyway. 

	-Mike



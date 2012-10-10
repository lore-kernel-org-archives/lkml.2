Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518Ab2JJLsO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 07:48:14 -0400
Received: from www.linutronix.de ([62.245.132.108]:42927 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144Ab2JJLsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 07:48:12 -0400
Date: Wed, 10 Oct 2012 13:48:10 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [ANNOUNCE] 3.6.1-rt1
In-Reply-To: <1349833878.24256.49.camel@gandalf.local.home>
Message-ID: <alpine.LFD.2.02.1210101347410.2853@ionos>
References: <alpine.LFD.2.02.1210091535140.10988@ionos>  <1349806792.24256.34.camel@gandalf.local.home>  <1349828517.24256.47.camel@gandalf.local.home> <1349833878.24256.49.camel@gandalf.local.home>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Oct 2012, Steven Rostedt wrote:

> On Tue, 2012-10-09 at 20:21 -0400, Steven Rostedt wrote:
> 
> > > 0007-stomp-machine-deal-clever-with-stopper-lock.patch
> > 
> > With this one, things have changed quite a bit. I'll take a deeper look
> > at what you did and figure out how this applies to v3.0-rt.
> 
> It doesn't look like this patch is needed for v3.0-rt as the patch
> addresses the new stop_machine_from_inactive_cpu() API used by the mtrr
> code added by this commit:
> 
> commit 192d8857427dd23707d5f0b86ca990c3af6f2d74
> Author: Suresh Siddha <suresh.b.siddha@intel.com>
> Date:   Thu Jun 23 11:19:29 2011 -0700
> 
>     x86, mtrr: use stop_machine APIs for doing MTRR rendezvous
> 
> 
> This was added in 3.1 so the patch is still required for v3.2-rt.

Correct. 3.0 is not affected.

	 tglx

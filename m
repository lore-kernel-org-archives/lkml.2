Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863Ab2HNKTI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 06:19:08 -0400
Received: from www.linutronix.de ([62.245.132.108]:57532 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755844Ab2HNKS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 06:18:59 -0400
Date: Tue, 14 Aug 2012 12:18:49 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
cc: Steven Rostedt <rostedt@goodmis.org>, mingo@kernel.org,
        paulmck@linux.vnet.ibm.com, josh@joshtriplett.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] preempt/hardirq.h: Clarify PREEMPT_ACTIVE bit location
In-Reply-To: <502A0C19.6010007@linux.vnet.ibm.com>
Message-ID: <alpine.LFD.2.02.1208141216120.32033@ionos>
References: <20120720192459.6149.14821.stgit@srivatsabhat.in.ibm.com> <1343706583.27983.28.camel@gandalf.stny.rr.com> <502A0C19.6010007@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Aug 2012, Srivatsa S. Bhat wrote:

> 
> By default, the PREEMPT_ACTIVE flag is bit 27, but different
> architectures can override that. Update the comment to reflect
> this fact.

Is there any sensible reason why architectures need to override that?
I can't find one.

If there is none, then we should just remove all the overrides from
the arch code instead. If there is a reason, then it should be
documented.

Thanks,

	tglx

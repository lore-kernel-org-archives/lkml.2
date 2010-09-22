Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216Ab0IVLun (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 07:50:43 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:50535 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751703Ab0IVLum (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 07:50:42 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18hkVl4+iEhWSx6f8xRIQXAnTKfSZdtWfCCPn2KbP
	atJJ3jbP158t5J
Subject: Re: [RFC PATCH] sched: START_NICE feature (temporarily niced
 forks) (v4)
From: Mike Galbraith <efault@gmx.de>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>
In-Reply-To: <1285077844.24680.176.camel@marge.simson.net>
References: <20100920191929.GA29026@Krystal>
	 <1285070478.24680.76.camel@marge.simson.net>
	 <1285077844.24680.176.camel@marge.simson.net>
Content-Type: text/plain
Date: Wed, 22 Sep 2010 13:51:04 +0200
Message-Id: <1285156264.7428.18.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-09-21 at 16:04 +0200, Mike Galbraith wrote:

> Perhaps take that vslice penalty, apply it to parent and child, and if
> present, deduct sleep time from their debt, and only credit sleep time
> if there's anything left over?  In any case, seems to me that sleep time
> has to be included in the equation while the penalty is in effect.
> 
> Guess I'll try that, see what happens.

Nothing good.  Several flavors thereof.

> (but that will likely negate much of the benefit for your testcase,
> where parent and child sleep)

(yup, it did)

BTTODB.

	-Mike


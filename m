Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758796Ab2CBPUL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 10:20:11 -0500
Received: from www.linutronix.de ([62.245.132.108]:43433 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755298Ab2CBPUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 10:20:06 -0500
Date: Fri, 2 Mar 2012 16:20:04 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Carsten Emde <C.Emde@osadl.org>, John Kacur <jkacur@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <clark.williams@gmail.com>
Subject: Re: [PATCH RT 7/9][RFC] [PATCH 7/9] cpu/rt: Rework cpu down for
 PREEMPT_RT
In-Reply-To: <1330701323.25686.260.camel@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.2.02.1203021618330.2742@ionos>
References: <20120301185527.064629423@goodmis.org>  <20120301190346.172835662@goodmis.org>  <alpine.LFD.2.02.1203021518501.2742@ionos> <1330701323.25686.260.camel@gandalf.stny.rr.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Mar 2012, Steven Rostedt wrote:

> On Fri, 2012-03-02 at 15:52 +0100, Thomas Gleixner wrote:
> 
> > So no, I rather keep the current problem than applying that insanity.
> 
> Note, patches 1,2,3,5 and 6, were bugs I found while debugging hotplug.
> Please add them, they are not insanity fixes but real bug fixes.

Already queued. I'd say #4 is a bug fix as well, though I
fundamentally hate the ass backwards semantics of that new function.
 
Thanks,

	tglx


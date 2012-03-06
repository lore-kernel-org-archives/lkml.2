Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758764Ab2CFNT5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 08:19:57 -0500
Received: from www.linutronix.de ([62.245.132.108]:57886 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264Ab2CFNT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 08:19:56 -0500
Date: Tue, 6 Mar 2012 14:19:53 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
        Clark Williams <clark@redhat.com>, John Kacur <jkacur@redhat.com>,
        Carsten Emde <cbe@osadl.org>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH RT] seqlock/rt: Prevent livelocks with seqlocks in RT
In-Reply-To: <1331036257.25686.365.camel@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.2.02.1203061418570.2742@ionos>
References: <1331006584.25686.362.camel@gandalf.stny.rr.com>  <alpine.LFD.2.02.1203060911000.2742@ionos> <1331036257.25686.365.camel@gandalf.stny.rr.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Mar 2012, Steven Rostedt wrote:
> On Tue, 2012-03-06 at 09:18 +0100, Thomas Gleixner wrote:
> Here's the real fix then:
> -#ifndef CONFIG_PREEMPT_RT
> +#ifndef CONFIG_PREEMPT_RT_FULL
>  static inline unsigned read_seqbegin(const seqlock_t *sl)

It's in rt16 already along with a missing fix for a networking inline
function.

Thanks,

	tglx

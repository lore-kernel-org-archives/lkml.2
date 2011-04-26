Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757808Ab1DZHZs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 03:25:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:38140 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757557Ab1DZHZq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 03:25:46 -0400
Subject: Re: [PATCH 0/4] munmap: Flexible mem unmap operation interface for
 scheduling latency
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Geunsik Lim <leemgs1@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Hugh Dickins <hughd@google.com>, Darren Hart <dvhart@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
In-Reply-To: <1303763393.18763.16.camel@gandalf.stny.rr.com>
References: <1303728272-11408-1-git-send-email-leemgs1@gmail.com>
	 <1303760837.4865.22.camel@laptop>
	 <1303763393.18763.16.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 26 Apr 2011 09:25:20 +0200
Message-ID: <1303802720.20212.7.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-25 at 16:29 -0400, Steven Rostedt wrote:
> On Mon, 2011-04-25 at 21:47 +0200, Peter Zijlstra wrote:
> 
> > Also, -rt doesn't care since it already has preemptible mmu_gather.
> 
> To be fair, he did state:
> 
> >     In general, This is not a critical latency-path on preemption mode
> >     (PREEMPT_VOLUNTARY / PREEMPT_DESKTOP / PREEMPT_RT)

That doesn't parse for me... what does it say? The only one not listed
is the non-preempt option, that wouldn't reschedule no matter what
ZAP_BLOCK_SIZE.

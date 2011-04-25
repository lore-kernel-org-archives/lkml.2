Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932581Ab1DYU36 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:29:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:51964 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932459Ab1DYU34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:29:56 -0400
X-Authority-Analysis: v=1.1 cv=ZtuXOl23UuD1yoJUTgnZ6i6Z5VPlPhPMWCeUNtN8OGA= c=1 sm=0 a=tM52yTxyLPgA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=V5b_7FpuGfKFuFnv8BsA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 0/4] munmap: Flexible mem unmap operation interface for
 scheduling latency
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Geunsik Lim <leemgs1@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Hugh Dickins <hughd@google.com>, Darren Hart <dvhart@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
In-Reply-To: <1303760837.4865.22.camel@laptop>
References: <1303728272-11408-1-git-send-email-leemgs1@gmail.com>
	 <1303760837.4865.22.camel@laptop>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 25 Apr 2011 16:29:53 -0400
Message-ID: <1303763393.18763.16.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-25 at 21:47 +0200, Peter Zijlstra wrote:

> Also, -rt doesn't care since it already has preemptible mmu_gather.

To be fair, he did state:

>     In general, This is not a critical latency-path on preemption mode
>     (PREEMPT_VOLUNTARY / PREEMPT_DESKTOP / PREEMPT_RT)



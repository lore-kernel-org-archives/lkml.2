Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968Ab2C0Smv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 14:42:51 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:39933 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755388Ab2C0Sms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 14:42:48 -0400
Date: Tue, 27 Mar 2012 20:42:43 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>, stable@vger.kernel.org
Subject: Re: [PATCH][GIT PULL][v3.4] tracing: Fix ent_size in trace output
Message-ID: <20120327184243.GA25330@gmail.com>
References: <1332869121.23924.130.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332869121.23924.130.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> Ingo,
> 
> Please pull the latest tip/perf/urgent tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
> tip/perf/urgent
> 
> Head SHA1: 12b5da349a8b94c9dbc3430a6bc42eabd9eaf50b
> 
> 
> Steven Rostedt (1):
>       tracing: Fix ent_size in trace output
> 
> ----
>  kernel/trace/trace.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)

Pulled, thanks Steve!

	Ingo

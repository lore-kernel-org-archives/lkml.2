Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155Ab2CVISj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 04:18:39 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:56071 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754369Ab2CVISe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 04:18:34 -0400
Date: Thu, 22 Mar 2012 09:18:30 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH][GIT PULL] tracing: Move the tracing_on/off()
 declarations into CONFIG_TRACING
Message-ID: <20120322081830.GA14381@gmail.com>
References: <1332283828.23924.17.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332283828.23924.17.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Ingo,
> 
> This fixes the bug you found with the config. I also added a test to my
> test suite, that includes that config combination of having RING_BUFFER
> enabled but TRACING not, to catch further bugs similar to this one.
> 
> -- Steve 
> 
> Please pull the latest tip/perf/core tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
> tip/perf/core
> 
> Head SHA1: 93d68e52295fb8b65ded6db49e32e63b6a203e0b
> 
> 
> Steven Rostedt (1):
>       tracing: Move the tracing_on/off() declarations into CONFIG_TRACING

Pulled, thanks Steve!

	Ingo

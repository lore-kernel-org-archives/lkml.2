Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040Ab2LHOnI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2012 09:43:08 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:54802 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755060Ab2LHOnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2012 09:43:06 -0500
Date: Sat, 8 Dec 2012 15:43:01 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/2] [GIT PULL][v3.7] ring-buffer: Bug fixes
Message-ID: <20121208144301.GD12011@gmail.com>
References: <20121130161238.909829067@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121130161238.909829067@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> Ingo,
> 
> This is based off of my last urgent pull request.
> 
> Please pull the latest tip/perf/urgent-2 tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
> tip/perf/urgent-2
> 
> Head SHA1: 9366c1ba13fbc41bdb57702e75ca4382f209c82f
> 
> 
> Steven Rostedt (2):
>       ring-buffer: Fix NULL pointer if rb_set_head_page() fails
>       ring-buffer: Fix race between integrity check and readers
> 
> ----
>  kernel/trace/ring_buffer.c |   16 +++++++++++++---
>  1 file changed, 13 insertions(+), 3 deletions(-)

Pulled, thanks Steve!

	Ingo

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467Ab2GFJQ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 05:16:28 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:36837 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab2GFJQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 05:16:25 -0400
Date: Fri, 6 Jul 2012 11:16:19 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Subject: Re: [PATCH 0/2] [GIT PULL][v3.5] ring-buffer: Fixes for the changes
 in the last merge window
Message-ID: <20120706091619.GE24449@gmail.com>
References: <20120629213545.533870841@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120629213545.533870841@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Ingo,
> 
> This patch series has a couple of fixes for bugs that snuck 
> into the last merge window. The first is a crash that can 
> happen because of an uninitialized list, and failing to 
> allocate the requested amount. This can happen by changing the 
> buffer_size_kb to a huge amount as the first change that is 
> done to it after booting up (note, the bug does not happen if 
> a successful change happens first).
> 
> The second patch can cause the ring buffer accounting (which 
> is used by the infrastructure of the ring buffer) to get out 
> of sync. This happens if you fill the buffer and then remove a 
> few pages from it while it is full.
> 
> The fixes are pretty simple, and should go into the 3.5-rc.
> 
> Please pull the latest tip/perf/urgent tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
> tip/perf/urgent
> 
> Head SHA1: 48fdc72f23ad9a9956e524a47843135d0bbc3317
> 
> 
> Vaibhav Nagarnaik (2):
>       ring-buffer: Fix crash due to uninitialized new_pages list head
>       ring-buffer: Fix accounting of entries when removing pages
> 
> ----
>  kernel/trace/ring_buffer.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Pulled, thanks!

	Ingo


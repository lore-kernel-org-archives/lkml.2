Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757331Ab0DRXZt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Apr 2010 19:25:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46123 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752858Ab0DRXZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Apr 2010 19:25:48 -0400
Date: Sun, 18 Apr 2010 16:23:26 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <greg@kroah.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jarkko Nikula <jhnikula@gmail.com>, Tony Lindgren <tony@atomide.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC patch] CFS fix place entity spread issue (v2)
In-Reply-To: <20100418225906.GA14337@Krystal>
Message-ID: <alpine.LFD.2.00.1004181622120.14500@i5.linux-foundation.org>
References: <20100418131302.GA3614@Krystal> <alpine.LFD.2.00.1004181317100.14500@i5.linux-foundation.org> <20100418225906.GA14337@Krystal>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 18 Apr 2010, Mathieu Desnoyers wrote:
> 
> Degradation of this particular workload is expected, because the nature of the
> large CFS spread issue favors Xorg: it gets litterally minutes of available
> vruntime, while most other threads (e.g. kernel build, audio playing, etc..)
> suffer from this.

In that case, I think your patch is fundamentally incorrect.

I care a _whole_ lot more about "usable desktop" than I care about some 
inane "available vruntime". If the current behavior breaks your vruntime 
rules, then the current behaviour is clearly _correct_.

			Linus

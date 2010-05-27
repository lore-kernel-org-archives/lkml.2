Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756872Ab0E0WjU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 18:39:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48062 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754592Ab0E0WjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 18:39:18 -0400
Date: Thu, 27 May 2010 15:34:51 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL, v2] perf changes
In-Reply-To: <20100525135200.GA21462@elte.hu>
Message-ID: <alpine.LFD.2.00.1005271533010.11382@i5.linux-foundation.org>
References: <20100524192531.GA15614@elte.hu> <20100525002221.GA30395@drongo> <20100525135200.GA21462@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 25 May 2010, Ingo Molnar wrote:
>
>  75 files changed, 1847 insertions(+), 3147 deletions(-)

I was excited by this ("A code _reduction_! Will wonders never cease?"), 
but it turns out that all of the reduction was due to removing some unused 
utility functions from the user-level tools.

The actual kernel still grew:

 32 files changed, 1327 insertions(+), 964 deletions(-)

oh well. Merged anyway.

		Linus

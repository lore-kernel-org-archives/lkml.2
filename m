Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870Ab0C2SFo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 14:05:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:60782 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319Ab0C2SFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 14:05:42 -0400
Subject: Re: [PATCH 2/2] perf: Use hot regs with software sched
 switch/migrate events
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, David Miller <davem@davemloft.net>
In-Reply-To: <20100329174723.GB5101@nowhere>
References: <1269753066-17246-1-git-send-regression-fweisbec@gmail.com>
	 <1269753066-17246-3-git-send-regression-fweisbec@gmail.com>
	 <1269852599.12097.159.camel@laptop>  <20100329174723.GB5101@nowhere>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Mar 2010 20:05:38 +0200
Message-ID: <1269885938.12097.367.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-29 at 19:47 +0200, Frederic Weisbecker wrote:
> 
> 
> I'm going to make a quick fix for perf_fetch_caller_regs() that
> passes task_pt_regs if exclude_kernel for perf/urgent,
> and I'll do the above cleanups/invasive fixes on perf/core.
> 
> 
ok, sounds sensible, thanks!


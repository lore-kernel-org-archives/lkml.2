Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255Ab1EJOrw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 10:47:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:52812 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753926Ab1EJOrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 10:47:51 -0400
Subject: Re: [PATCH] perf events, x86: Implement Sandybridge last-level
 cache events
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mike Galbraith <efault@gmx.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <1305037078.2226.18.camel@localhost>
References: <1304930382.3924.303.camel@minggr.sh.intel.com>
	 <1305022112.2914.40.camel@laptop>  <1305037078.2226.18.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 May 2011 16:29:32 +0200
Message-ID: <1305037772.2914.88.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-10 at 22:17 +0800, Lin Ming wrote:
> 
> I'm also not sure if the bits combination do count exactly
> L3_HIT/_MISS.
> 
<snip manual bits>

> May need some micro-benchmarks to verify it. 

either that or ask for clarification internally.


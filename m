Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759384Ab2ERSh1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 14:37:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:34201 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759091Ab2ERSh0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 14:37:26 -0400
Message-ID: <1337366237.573.106.camel@twins>
Subject: Re: [PATCH] sched/rt: fix SCHED_RR across cgroups
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Colin Cross <ccross@android.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Hillf Danton <dhillf@gmail.com>
Date: Fri, 18 May 2012 20:37:17 +0200
In-Reply-To: <CAMbhsRQYeM8b167HVge11kVtniWKEukN+xGMvcMDf5+UOOc8_w@mail.gmail.com>
References: <1337229266-15798-1-git-send-email-ccross@android.com>
	 <1337331395.573.3.camel@twins>
	 <CAMbhsRQYeM8b167HVge11kVtniWKEukN+xGMvcMDf5+UOOc8_w@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-18 at 10:52 -0700, Colin Cross wrote:

> > OK, fair enough.. one does wonder though, WTH is android doing with
> > SCHED_RR?
> 
> Nothing, I was just experimenting with how it interacted with cgroups
> and the numbers didn't make sense.

OK. Thanks anyway!

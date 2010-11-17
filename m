Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757970Ab0KQNbj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 08:31:39 -0500
Received: from casper.infradead.org ([85.118.1.10]:39241 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390Ab0KQNbi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 08:31:38 -0500
Subject: Re: [patch] trace: Add user-space event tracing/injection
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <20101117131037.GD5464@nowhere>
References: <alpine.LFD.2.00.1011162103580.2900@localhost6.localdomain6>
	 <4CE38C53.8090606@kernel.org> <20101117120740.GA24972@elte.hu>
	 <1289996994.2109.731.camel@laptop>  <20101117131037.GD5464@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 17 Nov 2010 14:31:27 +0100
Message-ID: <1290000687.2109.777.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-17 at 14:10 +0100, Frederic Weisbecker wrote:
> 
> 
> 
> Why not using write() on the perf event fd?
> So that you don't only limit to a custom new simple event (which should
> match most needs) but you can also inject whatever existing event you like.

Because you don't have the perf event fd, the monitoring application has
it.

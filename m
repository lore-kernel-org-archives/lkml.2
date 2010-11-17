Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758076Ab0KQNdb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 08:33:31 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41483 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757404Ab0KQNda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 08:33:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=fl9EUyIJQTpqf+SgqQcV4+4219gj38MqDLSsZR+SH+nP7WjkjrbESyfC73GGfh4rtg
         Z5RxN0/AP1wvqh3p381FHkJ5uIv+9UedeHS0+H4obqAGkYcnPSq+2FomJxLWElE3MrPi
         JfYQ8VuzgpvpLC5gxbD41Hal6rvua7kYcB6vc=
Date: Wed, 17 Nov 2010 14:33:25 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
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
Subject: Re: [patch] trace: Add user-space event tracing/injection
Message-ID: <20101117133321.GF5464@nowhere>
References: <alpine.LFD.2.00.1011162103580.2900@localhost6.localdomain6> <4CE38C53.8090606@kernel.org> <20101117120740.GA24972@elte.hu> <1289996994.2109.731.camel@laptop> <20101117131037.GD5464@nowhere> <1290000687.2109.777.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290000687.2109.777.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 02:31:27PM +0100, Peter Zijlstra wrote:
> On Wed, 2010-11-17 at 14:10 +0100, Frederic Weisbecker wrote:
> > 
> > 
> > 
> > Why not using write() on the perf event fd?
> > So that you don't only limit to a custom new simple event (which should
> > match most needs) but you can also inject whatever existing event you like.
> 
> Because you don't have the perf event fd, the monitoring application has
> it.


Ah, right.


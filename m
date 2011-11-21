Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284Ab1KUPBz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 10:01:55 -0500
Received: from smtpauth03.mfg.siteprotect.com ([64.26.60.137]:55571 "EHLO
	smtpauth03.mfg.siteprotect.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752335Ab1KUPBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 10:01:54 -0500
Date: Mon, 21 Nov 2011 10:02:09 -0500 (EST)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: mingo@elte.hu, William Cohen <wcohen@redhat.com>,
        Stephane Eranian <eranian@google.com>, Arun Sharma <asharma@fb.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 0/6] perf: x86 RDPMC and RDTSC support
In-Reply-To: <20111121145114.049265181@chello.nl>
Message-ID: <alpine.DEB.2.02.1111210959460.2903@pianoman.cluster.toy>
References: <20111121145114.049265181@chello.nl>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Nov 2011, Peter Zijlstra wrote:

> These few patches implement x86 RDPMC support and add an extention to the self
> monitoring data to also allow additional time updates using userspace TSC reads.
> 
> There's a few loose ends, but it mostly seems to work.

I'll have to test these out.  

I have some low-level benchmarks I've been working on, you can see some 
preliminary results here:
   http://web.eecs.utk.edu/~vweaver1/projects/perf-events/benchmarks/

perf_events was lagging behind perfmon2 and perfctr in self-monitoring 
overhead, but maybe these changes will help that.

perf_event overhead got a lot worse between 2.6.32 and 3.0, I'm mid-bisect 
on that trying to isolate the cause.

Vince


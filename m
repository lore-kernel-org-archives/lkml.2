Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758522Ab2IMP7G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 11:59:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19044 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758479Ab2IMP7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 11:59:00 -0400
X-Authority-Analysis: v=2.0 cv=VPlfbqzX c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=JBLNcV8zRgkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=B2NTZjWQ9qwA:10 a=16kj1NKcxtvoXTIdzgUA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1347551937.10751.80.camel@gandalf.local.home>
Subject: Re: [PATCH 1/7] perf: Enable function tracing for perf core
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>
Date: Thu, 13 Sep 2012 11:58:57 -0400
In-Reply-To: <20120908130646.GA2122@somewhere.redhat.com>
References: <20120908115515.211175517@goodmis.org>
	 <20120908115640.032328533@goodmis.org>
	 <20120908130646.GA2122@somewhere.redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-09-08 at 15:06 +0200, Frederic Weisbecker wrote:
> On Sat, Sep 08, 2012 at 07:55:16AM -0400, Steven Rostedt wrote:
> > According to Steven R. there is no reason left to not support
> > function tracing for the perf core. This makes it easier to debug
> > perf.
> > 
> > Don't remove -pg for the x86 and generic perf core.
> 
> Actually, perf can use function tracing. A good reason for disabling
> function tracing in perf is to avoid the overhead of recursive function
> tracing, even though we are protected against tracing re-entrancy, this
> still result in some overhead.

As I believe the patch set is being held off due to whether or not to
function trace perf, I'll rebase without it, and push the result again.
I'll add this to the queue of patches I have to trace the event
functions as well, as they seem to do the same things.

-- Steve



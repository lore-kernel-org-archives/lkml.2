Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760749Ab0HLSVr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 14:21:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55580 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753653Ab0HLSVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 14:21:46 -0400
Date: Thu, 12 Aug 2010 14:21:26 -0400
From: Don Zickus <dzickus@redhat.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Lin Ming <ming.m.lin@intel.com>,
        Ingo Molnar <mingo@elte.hu>, "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v2] perf, x86: try to handle unknown nmis with running
 perfctrs
Message-ID: <20100812182126.GM4879@redhat.com>
References: <20100804161046.GC5130@lenovo>
 <20100804162026.GU3353@redhat.com>
 <20100804163930.GE5130@lenovo>
 <20100804184806.GL26154@erda.amd.com>
 <20100804192634.GG5130@lenovo>
 <20100806065203.GR26154@erda.amd.com>
 <20100806142131.GA1874@redhat.com>
 <20100809194829.GB26154@erda.amd.com>
 <20100811220058.GT26154@erda.amd.com>
 <20100812131007.GW26154@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100812131007.GW26154@erda.amd.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 03:10:07PM +0200, Robert Richter wrote:
> On 12.08.10 00:00:58, Robert Richter wrote:
> > I was debuging this a little more, see version 2 below.
> 
> I was testing the patch further, it properly filters perfctr
> back-to-back nmis. I was able to reliable detect unknown nmis
> triggered by the nmi button during high load perf sessions with
> multiple counters, no false positives.

For my own curiousity, what type of high load perf sessions are you using
to test this.  I don't know perf well enough to have it generate events
across multiple perfctrs.

Thanks,
Don

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552Ab1HAFuR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 01:50:17 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:2451
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752804Ab1HAFuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 01:50:14 -0400
X-SpamScore: -11
X-BigFish: VPS-11(zz936eK1432N98dKzz1202hzzz32i668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LP8IVI-02-0ED-02
X-M-MSG: 
Date: Mon, 1 Aug 2011 07:50:08 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/7] perf, x86: Example code for AMD IBS
Message-ID: <20110801055008.GZ4590@erda.amd.com>
References: <1311860812-28748-1-git-send-email-robert.richter@amd.com>
 <1311860812-28748-7-git-send-email-robert.richter@amd.com>
 <1311958729.5890.413.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1311958729.5890.413.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.07.11 12:58:49, Peter Zijlstra wrote:
> On Thu, 2011-07-28 at 15:46 +0200, Robert Richter wrote:
> >  tools/perf/Documentation/examples/ibs.c    |  436 ++++++++++++++++++++++++++++
> 
> That really isn't the place for this..
> 
> Also, how similar is the Alpha PMU to AMD IBS?

Would you prefer

 tools/perf/Documentation/examples/x86/ibs.c

instead?

Actually I wasn't sure if this place is ok at all. But I wanted to
publish the code for reference and testing. There isn't somthing
similar already there, and the perf tool code is also not the best
place to implement such cpu specific features.

But putting it to the documentation is common practice for library
packages (e.g. libpapi and libpfm). If the example is not for the
given architecture it won't be added to the package documentation.
This example won't be installed at all. Even for very special features
an example is important since it is often not part of the generic
implementation.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637Ab1HAGNO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 02:13:14 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:21363 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266Ab1HAGNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 02:13:05 -0400
X-SpamScore: -11
X-BigFish: VPS-11(zz936eK1432N98dKzz1202hzzz32i668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LP8JXL-02-14P-02
X-M-MSG: 
Date: Mon, 1 Aug 2011 08:13:00 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/7] perf, x86: Implement 64 bit counter support for IBS
Message-ID: <20110801061300.GB4590@erda.amd.com>
References: <1311860812-28748-1-git-send-email-robert.richter@amd.com>
 <1311860812-28748-8-git-send-email-robert.richter@amd.com>
 <1311958863.5890.415.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1311958863.5890.415.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.07.11 13:01:03, Peter Zijlstra wrote:
> On Thu, 2011-07-28 at 15:46 +0200, Robert Richter wrote:
> > The functions perf_event_set_period() and perf_event_try_update() can
> > be used as generic functions. They can replace similar code that is
> > duplicate across architectures.
> 
> We could perhaps place them in kernel/events/pmu-lib.c or so, a place to
> gather useful common code to pmu driver implementations.

As we already have kernel/events/core.c I suggest to put it into
.../common.c?

I planned to factor this out of current perf code for x86 and maybe
other architectures. Want to send separate patches independent from
ibs.

Should I add both functions already to the new file? Maybe this has
some implications to header and makefiles.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center


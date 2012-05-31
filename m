Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932662Ab2EaPvh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 11:51:37 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:18574
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932615Ab2EaPvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 11:51:35 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dKzz1202hzzz2dh668h839h944hd25hf0ah)
X-WSS-ID: 0M4W9DQ-02-F0L-02
X-M-MSG: 
Date: Thu, 31 May 2012 17:51:19 +0200
From: Robert Richter <robert.richter@amd.com>
To: Stephane Eranian <eranian@google.com>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/7] perf/x86-ibs and tools: Add support for AMD IBS
Message-ID: <20120531155119.GU18810@erda.amd.com>
References: <1335983192-23731-1-git-send-email-robert.richter@amd.com>
 <CABPqkBQU5=hcCbDCeG1r7G7hy70S9M3GyXaBKcjzn5AtdwQO-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CABPqkBQU5=hcCbDCeG1r7G7hy70S9M3GyXaBKcjzn5AtdwQO-g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31.05.12 17:24:25, Stephane Eranian wrote:

> I think the script ibs.pl would be more useful if it were to offer the
> option to decrypt
> each IBS register. I am not a Perl programmer, so I had a hard time
> understanding
> the way one can use pack()/unpack() to extract bitfields from a u64 value.

Stephane, I didn't spent the effort yet to implement a complete IBS
sample parser in userland. This could be done with a later update. My
intention was to give the perl script out anyway as it helps to dump
the raw register values. It can easy be extended or grep'ed directly
for bit combinations of certain registers.

For the implementation of an ibs sample parser I was thinking of
extending perf-report, but so far I don't have something. Another
option I plan to implement is userland sample filtering. Pseudo events
could be extracted from the raw data which is then equivalent to a
sample parser.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center


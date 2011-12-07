Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701Ab1LGIbP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 03:31:15 -0500
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:49477
	"EHLO AM1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752660Ab1LGIbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 03:31:13 -0500
X-SpamScore: -9
X-BigFish: VPS-9(zz1432N98dKzz1202hzzz2dh668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LVTRNS-02-52G-02
X-M-MSG: 
Date: Wed, 7 Dec 2011 09:30:50 +0100
From: Robert Richter <robert.richter@amd.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10/10] perf tools: Use for_each_set_bit() to iterate over
 feature flags
Message-ID: <20111207083050.GP15738@erda.amd.com>
References: <1323167560-2282-1-git-send-email-robert.richter@amd.com>
 <1323167560-2282-11-git-send-email-robert.richter@amd.com>
 <20111206134054.GJ7059@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20111206134054.GJ7059@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06.12.11 11:40:54, Arnaldo Carvalho de Melo wrote:
> What would be really great would be to just use the kernel one like in
> 
> tools/perf/util/include/linux/list.h
> tools/perf/util/include/linux/rbtree.h
> 
> But that was source of contention in the past when changes in the kernel
> side broke the tools, i.e. the headers were not explicitely designed for
> such sharing.

Yeah, that didn't work out, esp. because of architectural includes and
optimizations. For most cases we don't need that level of optimization
since code is not used in the fast path.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center


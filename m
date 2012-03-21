Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757408Ab2CUMeB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 08:34:01 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:44381
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755914Ab2CUMd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 08:33:59 -0400
X-SpamScore: -9
X-BigFish: VPS-9(zz1432N98dKzz1202hzz8275dhz2dh668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M18IWD-02-B5L-02
X-M-MSG: 
Date: Wed, 21 Mar 2012 13:33:48 +0100
From: Robert Richter <robert.richter@amd.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Lin Ming <ming.m.lin@intel.com>, Jiri Olsa <jolsa@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: linux-next: manual merge of the oprofile tree with the tip tree
Message-ID: <20120321123348.GJ16322@erda.amd.com>
References: <20120321163151.83cad17d5524424938f7576c@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120321163151.83cad17d5524424938f7576c@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.03.12 16:31:51, Stephen Rothwell wrote:
> Today's linux-next merge of the oprofile tree got a conflict in
> tools/perf/util/parse-events.c between commit 89812fc81f8d ("perf tools:
> Add parser generator for events parsing") from the tip tree and commit
> 1e48600d2388 ("perf tool: Parse general/raw events from sysfs") from the
> oprofile tree.
> 
> I have no idea how to fix this up, so I effectively dropped this patch
> from the oprofile tree.

Yeah, the trees are totally different now. Removed my tree from
for-next.

Btw, please switch my for-next tree back to kernel.org:

 git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git for-next

Thanks.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center


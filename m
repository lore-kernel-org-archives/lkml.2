Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759575Ab2D0QKC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 12:10:02 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:2472
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758889Ab2D0QKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 12:10:00 -0400
X-SpamScore: -12
X-BigFish: VPS-12(zz936eK1432N98dKzz1202hzzz2dh668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M35BKH-02-8OB-02
X-M-MSG: 
Date: Fri, 27 Apr 2012 18:09:22 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/12] perf/x86-ibs: Precise event sampling with IBS for
 AMD CPUs
Message-ID: <20120427160922.GI18810@erda.amd.com>
References: <1333390758-10893-1-git-send-email-robert.richter@amd.com>
 <1333390758-10893-7-git-send-email-robert.richter@amd.com>
 <1334398906.2528.49.camel@twins>
 <20120423095659.GS9747@erda.amd.com>
 <20120427123434.GF18810@erda.amd.com>
 <CABPqkBS9FNmHBukzJqGJP1r5iqyLL9gz2g=3jvnt22pDxOdndA@mail.gmail.com>
 <20120427125410.GG18810@erda.amd.com>
 <1335540633.2463.133.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1335540633.2463.133.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.04.12 17:30:33, Peter Zijlstra wrote:
> On Fri, 2012-04-27 at 14:54 +0200, Robert Richter wrote:
> > My suggestions was to use level 1 for all samples and level 2 for
> > samples that only contain a precise rip, saving level 3 for future
> > use. 
> 
> No.

Ok, will look how to handle this in userspace.

But do you agree to have level 1 and 2 mapped to ibs, not just only
level 2 (since I don't want to fail with r076:p)?

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center


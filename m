Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759643Ab2FUN30 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 09:29:26 -0400
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:50439
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753522Ab2FUN3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 09:29:24 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zf7Iz98dIzz1202hzzz2dh668h839h944hd25hf0ah)
X-WSS-ID: 0M5YYSS-02-0P0-02
X-M-MSG: 
Date: Thu, 21 Jun 2012 15:29:14 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Luming Yu <luming.yu@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        <tglx@linutronix.de>, <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>, <jcm@jonmasters.org>,
        <linux-next@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        <torvalds@linux-foundation.org>
Subject: Re: What is the right practice to get new code upstream( was Fwd:
 [patch] a simple hardware detector for latency as well as throughput ver.
 0.1.0)
Message-ID: <20120621132914.GA24632@erda.amd.com>
References: <CAJRGBZw2TctmBxRuA-byaGNCs=1v+M-1PXSm+OuwWApSqu7UjA@mail.gmail.com>
 <1339668296.2559.25.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1339668296.2559.25.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14.06.12 12:04:56, Peter Zijlstra wrote:
 For AMD there's only event 02Bh, which is SMIs Received. I'm not sure it
> has anything like the FREEZE or if the event is modifyable to count the
> cycles in SMI.

Peter, which use cases do you have in mind. Is it to root cause
latencies? Or just to see what happens on the system, you long it
spends in smi mode? On current systems counting smi cycles seems not
to be possible.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center


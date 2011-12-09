Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751843Ab1LIWWT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 17:22:19 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:33525
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750829Ab1LIWWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 17:22:15 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzzz2dh87h2a8h668h839h8e2h8e3h944h66h)
X-Spam-TCS-SCL: 5:0
X-Forefront-Antispam-Report: CIP:160.36.179.112;KIP:(null);UIP:(null);IPV:NLI;H:kedge2.utk.tennessee.edu;RD:kedge2.utk.tennessee.edu;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
Date: Fri, 9 Dec 2011 17:22:09 -0500
From: Vince Weaver <vweaver1@eecs.utk.edu>
To: <eranian@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: perf_event self-monitoring overhead regression
In-Reply-To: <CAMsRxfL3NVuz0dL-=iTJUsPMBt1frcfQ43fyc8pNoHEM9NXiOg@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1112091717390.18889@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1111300011260.7107@cl320.eecs.utk.edu> <1322654092.2921.256.camel@twins> <CA+55aFwyYdN7HOkP0xanUOWd12zZhdqHCjnsWtdrs5LOxjg+Gg@mail.gmail.com> <alpine.DEB.2.00.1112010853430.31445@cl320.eecs.utk.edu>
 <CAMsRxfJmXXxDrofY3PDOLWRC7E-o6mANiTSJwYbyMTgOT_J0UA@mail.gmail.com> <alpine.DEB.2.00.1112061604040.23414@cl320.eecs.utk.edu> <CAMsRxfL3NVuz0dL-=iTJUsPMBt1frcfQ43fyc8pNoHEM9NXiOg@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Here are the complete results, using official kernels.

   http://web.eecs.utk.edu/~vweaver1/projects/perf-events/benchmarks/rdtsc_overhead/

The overall overhead start/stop/read has been getting worse.  3.1.0 was 
bad and the current 3.2.0-rc4-tip tree is even worse.

I'm not sure if it's worth trying to track down the changes that cause 
these regressions, as they might still be considered just noise, though 
the best to worst performance degredation is ~ 15% when attempting to 
self-monitor with 3 events on a core2 machine.

Vince


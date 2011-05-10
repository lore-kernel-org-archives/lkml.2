Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557Ab1EJPF7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 11:05:59 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:59438
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756505Ab1EJPF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 11:05:57 -0400
X-SpamScore: -11
X-BigFish: VPS-11(zz936eK1432N98dKzz1202hzzz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LKZJ6Z-01-71Z-02
X-M-MSG: 
Date: Tue, 10 May 2011 17:04:12 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        benh <benh@kernel.crashing.org>, Anton Blanchard <anton@samba.org>,
        davem <davem@davemloft.net>
Subject: Re: [PATCH 2/3] perf, x86: Use GO/HO bits in perf-ctr
Message-ID: <20110510150412.GB30996@amd.com>
References: <1305038132-5080-1-git-send-email-joerg.roedel@amd.com>
 <1305038132-5080-3-git-send-email-joerg.roedel@amd.com>
 <1305038900.2914.97.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1305038900.2914.97.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 10, 2011 at 10:48:20AM -0400, Peter Zijlstra wrote:
> On Tue, 2011-05-10 at 16:35 +0200, Joerg Roedel wrote:
> > The AMD perf-counters support counting in guest or host-mode
> > only. Make use of that feature when user-space specified
> > guest/host-mode only counting.
> 
> Subject mentions x86, does Intel have anything similar so you can make
> it work for them too?

Intel does not support guest or host-only counting in the hardware (at
least according to my documentation). If wanted it could be approximated by
enabling/disabling the counters in the guest-entry path.
So subject should better say "perf, amd", right?

> Also, might be nice to ask the power and sparc64 people if their archs
> can also differentiate between guest and host thingies.

Right, I don't know if their hardware has similar features. I'll try to
find this out.

	Joerg



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756688Ab1KUUga (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 15:36:30 -0500
Received: from merlin.infradead.org ([205.233.59.134]:46156 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756610Ab1KUUgZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 15:36:25 -0500
Message-ID: <1321907755.28118.30.camel@twins>
Subject: Re: [RFC][PATCH 2/6] perf, arch: Rework perf_event_index()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Will Deacon <will.deacon@arm.com>
Cc: "mingo@elte.hu" <mingo@elte.hu>, William Cohen <wcohen@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Cree <mcree@orcon.net.nz>,
        Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
        Anton Blanchard <anton@samba.org>, Eric B Munson <emunson@mgebm.net>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Richard Kuo <rkuo@codeaurora.org>,
        Stephane Eranian <eranian@google.com>, Arun Sharma <asharma@fb.com>,
        Vince Weaver <vince@deater.net>
Date: Mon, 21 Nov 2011 21:35:55 +0100
In-Reply-To: <20111121203145.GA7301@mudshark.cambridge.arm.com>
References: <20111121145114.049265181@chello.nl>
	 <20111121145337.533322271@chello.nl>
	 <20111121172323.GH20611@mudshark.cambridge.arm.com>
	 <1321903090.28118.21.camel@twins>
	 <20111121203145.GA7301@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-21 at 20:31 +0000, Will Deacon wrote:
> On Mon, Nov 21, 2011 at 07:18:10PM +0000, Peter Zijlstra wrote:
> > But does ARM have a read PMU counter from userspace
> > instruction/capability?
> 
> In ARMv7, you can enable user access to the performance counters but the
> access is R/W so I don't think it's something we want to do (could interfere
> with another task doing system-wide profiling).

Yeah, write access is pushing it a bit.. 

> > Lacking that its all moot of course. If it does, it would be nice to
> > have an ARM version of patch 6.
> 
> Well we'd need a way to get around the all-or-nothing user access to the PMU
> and also the fact that we don't always have a user-readable clocksource.
> 
> Either way, the event counters are indexed from 0 on ARMv7 so we should
> use perf_event_idx_default.

Ok, done. Thanks!

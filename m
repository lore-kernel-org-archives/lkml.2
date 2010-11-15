Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058Ab0KOLGs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 06:06:48 -0500
Received: from canuck.infradead.org ([134.117.69.58]:39502 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755909Ab0KOLGr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 06:06:47 -0500
Subject: Re: [PATCH 1/2] perf-events: Add support for supplementary event
 registers v2
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu, fweisbec@gmail.com,
        Andi Kleen <ak@linux.intel.com>
In-Reply-To: <AANLkTin6rOx_gPkNET3arpx8LFJt_9sZUOBXna=WuFKq@mail.gmail.com>
References: <1289580941-29744-1-git-send-email-andi@firstfloor.org>
	 <1289582630.2084.331.camel@laptop>
	 <20101113101148.GB6418@gargoyle.fritz.box>
	 <1289644367.2084.526.camel@laptop>
	 <AANLkTin6rOx_gPkNET3arpx8LFJt_9sZUOBXna=WuFKq@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 15 Nov 2010 12:06:41 +0100
Message-ID: <1289819201.2109.489.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-15 at 12:01 +0100, Stephane Eranian wrote:
> On Sat, Nov 13, 2010 at 11:32 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > On Sat, 2010-11-13 at 11:13 +0100, Andi Kleen wrote:
> >> > Hrmm,. this doesn't really scale right wrt multiple extra_regs.
> >> >
> >> > You made the extra_regs thing fairly extensible, but the above doesn't
> >> > really work well if there's multiple extra regs (say OFFCORE and
> >> > LBR_CONFIG -- possibly even the two OFFCORE regs present on westmere).
> >> >
> >> > It basically needs a per-core state for each extra_reg possible.
> >>
> >> It shouldn't be too hard to extend it to use a table. I didn't want
> >> to do that for the first iteration. I guess it could be done as followons
> >> once LBR is implemented.
> >
> > Isn't it also relevant for the two offcore regs for wsm?
> >
> But that's two distinct events (0xbb and 0xb7), though they behave
> exactly the same and have the same set of umasks and extra MSR
> values.

Ah, my bad, I thought there were two separate msrs, ok I'll take a last
look at these patches and if nothing else pops out I'll take them.

Thanks!

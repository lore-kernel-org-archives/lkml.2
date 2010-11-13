Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929Ab0KMKcn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 05:32:43 -0500
Received: from canuck.infradead.org ([134.117.69.58]:41133 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298Ab0KMKcm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 05:32:42 -0500
Subject: Re: [PATCH 1/2] perf-events: Add support for supplementary event
 registers v2
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andi Kleen <andi@firstfloor.org>
Cc: eranian@google.com, linux-kernel@vger.kernel.org,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu, fweisbec@gmail.com,
        Andi Kleen <ak@linux.intel.com>
In-Reply-To: <20101113101148.GB6418@gargoyle.fritz.box>
References: <1289580941-29744-1-git-send-email-andi@firstfloor.org>
	 <1289582630.2084.331.camel@laptop>
	 <20101113101148.GB6418@gargoyle.fritz.box>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 13 Nov 2010 11:32:47 +0100
Message-ID: <1289644367.2084.526.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-11-13 at 11:13 +0100, Andi Kleen wrote:
> > Hrmm,. this doesn't really scale right wrt multiple extra_regs.
> > 
> > You made the extra_regs thing fairly extensible, but the above doesn't
> > really work well if there's multiple extra regs (say OFFCORE and
> > LBR_CONFIG -- possibly even the two OFFCORE regs present on westmere).
> > 
> > It basically needs a per-core state for each extra_reg possible.
> 
> It shouldn't be too hard to extend it to use a table. I didn't want
> to do that for the first iteration. I guess it could be done as followons
> once LBR is implemented.

Isn't it also relevant for the two offcore regs for wsm?

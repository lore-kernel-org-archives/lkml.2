Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560Ab0KMJKa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 04:10:30 -0500
Received: from one.firstfloor.org ([213.235.205.2]:58928 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755305Ab0KMJK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 04:10:26 -0500
Date: Sat, 13 Nov 2010 11:13:03 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: eranian@google.com, linux-kernel@vger.kernel.org,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu, fweisbec@gmail.com,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/2] perf-events: Add support for supplementary event
 registers v2
Message-ID: <20101113101148.GB6418@gargoyle.fritz.box>
References: <1289580941-29744-1-git-send-email-andi@firstfloor.org>
 <1289582630.2084.331.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289582630.2084.331.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hrmm,. this doesn't really scale right wrt multiple extra_regs.
> 
> You made the extra_regs thing fairly extensible, but the above doesn't
> really work well if there's multiple extra regs (say OFFCORE and
> LBR_CONFIG -- possibly even the two OFFCORE regs present on westmere).
> 
> It basically needs a per-core state for each extra_reg possible.

It shouldn't be too hard to extend it to use a table. I didn't want
to do that for the first iteration. I guess it could be done as followons
once LBR is implemented.

-Andi

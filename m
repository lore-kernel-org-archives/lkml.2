Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932333Ab0KOLbv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 06:31:51 -0500
Received: from one.firstfloor.org ([213.235.205.2]:33458 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755444Ab0KOLbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 06:31:50 -0500
Date: Mon, 15 Nov 2010 12:31:48 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, cjashfor@linux.vnet.ibm.com,
        mingo@elte.hu, fweisbec@gmail.com, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/2] perf-events: Add support for supplementary event
 registers v2
Message-ID: <20101115113148.GG7269@basil.fritz.box>
References: <1289580941-29744-1-git-send-email-andi@firstfloor.org>
 <1289582630.2084.331.camel@laptop>
 <20101113101148.GB6418@gargoyle.fritz.box>
 <1289644367.2084.526.camel@laptop>
 <AANLkTin6rOx_gPkNET3arpx8LFJt_9sZUOBXna=WuFKq@mail.gmail.com>
 <1289819201.2109.489.camel@laptop>
 <AANLkTinjpsGyZ-j9Pw2y=2YA8++HxHymbKUNcKgwssra@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinjpsGyZ-j9Pw2y=2YA8++HxHymbKUNcKgwssra@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Why would you want to measure both at the same time?
> Because you can measure two distinct request/response in one run.
> 
> If you want to measure both you need to create two distinct perf events.

What I did currently was to assign some cache events to 0xb7 and
others to bb on Westmere. That's a bit arbitrary, but allows to 
measure some common combinations together at least.

In theory one could teach the scheduler that these events
are equivalent, but that seems like too much complexity for 
me currently.
-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

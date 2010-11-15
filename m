Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932324Ab0KOLRa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 06:17:30 -0500
Received: from one.firstfloor.org ([213.235.205.2]:53006 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756011Ab0KOLR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 06:17:29 -0500
Date: Mon, 15 Nov 2010 12:17:27 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, cjashfor@linux.vnet.ibm.com,
        mingo@elte.hu, fweisbec@gmail.com, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/2] perf-events: Add support for supplementary event
 registers v2
Message-ID: <20101115111727.GF7269@basil.fritz.box>
References: <1289580941-29744-1-git-send-email-andi@firstfloor.org>
 <1289582630.2084.331.camel@laptop>
 <20101113101148.GB6418@gargoyle.fritz.box>
 <1289644367.2084.526.camel@laptop>
 <AANLkTin6rOx_gPkNET3arpx8LFJt_9sZUOBXna=WuFKq@mail.gmail.com>
 <1289819201.2109.489.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289819201.2109.489.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Ah, my bad, I thought there were two separate msrs, ok I'll take a last
> look at these patches and if nothing else pops out I'll take them.

There are actually two separate MSRs. I'm redoing my patchkit to handle
them. I also found another problem I'm fixing.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.

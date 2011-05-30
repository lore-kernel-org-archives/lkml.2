Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240Ab1E3TL3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 15:11:29 -0400
Received: from mga03.intel.com ([143.182.124.21]:31804 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750783Ab1E3TL1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 15:11:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,293,1304319600"; 
   d="scan'208";a="4119814"
From: "Brown, Len" <len.brown@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Len Brown <lenb@kernel.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "stable@kernel.org" <stable@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 30 May 2011 12:11:25 -0700
Subject: RE: linux-next: build warningiIn Linus' tree
Thread-Topic: linux-next: build warningiIn Linus' tree
Thread-Index: AcwenBVFCaJr+iVcTjCfw6d0TE7tNgAXVHsg
Message-ID: <E87738D94A6AD54789B5B8D1BAEB06CC701ED3BA3E@azsmsx503.amr.corp.intel.com>
References: <20110530114828.8ef6625b.sfr@canb.auug.org.au>
 <alpine.LFD.2.02.1105292346340.10035@arrandale.kernel.org>
 <20110530073445.GA27557@elte.hu>
In-Reply-To: <20110530073445.GA27557@elte.hu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Len, i'd *really* prefer it if patches changing arch/x86/ had a
> longer test time in linux-next than what you are gave it here.

I agree 100%, and I will do better in the future.

This was very difficult timing for a merge window for me.

> these patches were contentious when you last posted
> them as an RFC to lkml ...

The idle cleanup patches were contentious when I posed them
because my original proposal deleted a bunch of code right away.

Alan convinced me that the community doesn't move that fast,
and that we should wallow in the swill for a while longer before
deleting.  Others volunteered to test the latest upstream kernel
on APM hardware, giving APM's presence in the upstream kernel a life line.
So all I did was add the recommended feature-removal's and warnings
for the stuff which obviously should go.  But if you see some of
your favorite bits on the chopping block, you have at least
6 months to make a case for them:-)

thanks,
-Len


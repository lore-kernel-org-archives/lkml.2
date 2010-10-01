Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932632Ab0JANWa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 09:22:30 -0400
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:41217
	"EHLO AM1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932406Ab0JANWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 09:22:15 -0400
X-SpamScore: -23
X-BigFish: VPS-23(zzbb2cK1432N98dN111aL148cMzz1202hzzz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L9M54E-01-BR6-02
X-M-MSG: 
Date: Fri, 1 Oct 2010 15:21:52 +0200
From: Robert Richter <robert.richter@amd.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Will Deacon <will.deacon@arm.com>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: linux-next: manual merge of the oprofile tree with the tip tree
Message-ID: <20101001132151.GC13563@erda.amd.com>
References: <20101001135301.5307c860.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20101001135301.5307c860.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30.09.10 23:53:01, Stephen Rothwell wrote:
> Today's linux-next merge of the oprofile tree got a conflict in
> arch/arm/oprofile/common.c between commit
> 98d943b02f6f1b57787ff1aa6f34d019a407e3ee ("oprofile, ARM: Release
> resources on failure") from the tip tree and commit
> c7fd239a647ead1c336a051012d6bb96465ea8c6 ("ARM: oprofile: fix and
> simplify init/exit functions") from the oprofile tree.
> 
> I fixed it up (I think - see below) and can carry the fix as necessary.

Stephen,

thanks for catching this. I have updated the oprofile/for-next tree
and now it should merge without conflicts with tip.

Will,

you may pull the merge from oprofile/core too.

Thanks again,

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center


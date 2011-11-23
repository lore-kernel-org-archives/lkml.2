Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759691Ab1KWCIX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 21:08:23 -0500
Received: from dns1.mips.com ([12.201.5.69]:41561 "EHLO dns1.mips.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756020Ab1KWCIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 21:08:22 -0500
Message-ID: <4ECC555D.4080902@mips.com>
Date: Wed, 23 Nov 2011 10:07:25 +0800
From: Deng-Cheng Zhu <dczhu@mips.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Ralf Baechle <ralf@linux-mips.org>
Subject: Re: linux-next: manual merge of the tip tree with the mips tree
References: <20111123130148.2a437aabdf6120e7e9b6928c@canb.auug.org.au>
In-Reply-To: <20111123130148.2a437aabdf6120e7e9b6928c@canb.auug.org.au>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-EMS-Proccessed: 6LP3oGfGVdcdb8o1aBnt6w==
X-EMS-STAMP: I6ZEWUXLj+JKv0lsR0bt3g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23/2011 10:01 AM, Stephen Rothwell wrote:
> Hi all,
>
> Today's linux-next merge of the tip tree got a conflict in
> arch/mips/kernel/perf_event_mipsxx.c between commit f40c522a4216
> ("MIPS/Perf-events: Remove erroneous check on active_events") and
> c481e48d9478 ("MIPS/Perf-events: Remove pmu and event state checking in
> validate_event()") from the mips tree and commit aa2bc1ade590 ("perf:
> Don't use -ENOSPC for out of PMU resources") from the tip tree.
>
> Just context changes (and one hunk was removed).  I fixed it up (see
> below) and can carry the fix as necessary.

Yes, I was aware of this conflict while writing that patch series based
on linux-mips tree. Your changes look good to me. Thanks for the fixup!


Deng-Cheng

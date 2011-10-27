Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754463Ab1J0HMd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 03:12:33 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41775 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753381Ab1J0HMc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 03:12:32 -0400
Date: Thu, 27 Oct 2011 09:10:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "hpanvin@gmail.com" <hpa@zytor.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL, v2] x86/mm changes for v3.2
Message-ID: <20111027071054.GA14858@elte.hu>
References: <20111026153600.GA819@elte.hu>
 <20111026163126.GC660@phenom.dumpdata.com>
 <6bee402a-c83c-4903-8cf3-24de582247f8@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6bee402a-c83c-4903-8cf3-24de582247f8@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* hpanvin@gmail.com <hpa@zytor.com> wrote:

> Yes... I thought we had agreed that as ugly as the hook it is 
> better than the fragility of second-guessing other code.  I would 
> like to see something automatically correct by construction, but 
> that seems to be really difficult for reasons I don't remember, 
> possibly having to do with bad Xen setup APIs.

Okay.

Linus, please ignore this pull request.

Peter, once you get some time please sort out which of these commits 
we want to keep:

 b17a5f97d413: x86_32: Calculate additional memory needed by the fixmap
 2e9fbad5955f: x86-64, mm: Do not assume head_64.S used 4KB pages when !use_pse
 1938931a20da: x86, init : Move memblock_x86_reserve_range PGTABLE to find_early_table_space
 d8ca7b16cfc1: Revert "x86,xen: introduce x86_init.mapping.pagetable_reserve"
 8e7f9f8d4076: x86, mm: Calculate precisely the memory needed by init_memory_mapping

for example 2e9fbad5955f looks independent.

Thanks,

	Ingo

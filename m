Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757763Ab1BPItO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 03:49:14 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44208 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753046Ab1BPItK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 03:49:10 -0500
Date: Wed, 16 Feb 2011 09:48:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, brgerst@gmail.com, gorcunov@gmail.com,
        shaohui.zheng@intel.com, rientjes@google.com, hpa@linux.intel.com
Subject: Re: [PATCH 15/26] x86-64, NUMA: Unify the rest of memblk registration
Message-ID: <20110216084852.GA17732@elte.hu>
References: <20110214162247.GX18742@htj.dyndns.org>
 <AANLkTi=1xKqmedFqHPgDR32OrmNXg-T34NFo8qEnymfp@mail.gmail.com>
 <20110214182718.GB18742@htj.dyndns.org>
 <4D597D56.5060408@kernel.org>
 <20110214193050.GC18742@htj.dyndns.org>
 <4D5983EA.4020103@kernel.org>
 <20110215091103.GC3160@htj.dyndns.org>
 <20110215094327.GA1387@elte.hu>
 <20110215164920.GR3160@htj.dyndns.org>
 <20110216084105.GG16529@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110216084105.GG16529@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > If you want the whole series reposted, please let me know.

Actually, it would be nice if you could merge your tree to the latest x86/mm tree i 
have just pushed out :-/

The problem is that your work is so wide that it conflicts with x86/mm, x86/bootmem, 
x86/amd-nb and x86/mm:

arch/x86/include/asm/amd_nb.h
arch/x86/include/asm/page_types.h
arch/x86/mm/amdtopology_64.c
arch/x86/mm/init_64.c
arch/x86/mm/numa_64.c
arch/x86/mm/srat_64.c

I consolidated all these topics into the generic x86/mm tree which you could use as 
a base.

I did not recognize the level of conflicts until i tried to pull your tree. You can 
generally test such interactions with other bits of the x86 tree by test-merging 
your pending work to tip:master.

Thanks,

	Ingo

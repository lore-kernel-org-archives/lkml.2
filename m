Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678Ab2LRKK3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 05:10:29 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37016 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753924Ab2LRKK1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 05:10:27 -0500
Date: Tue, 18 Dec 2012 10:10:21 +0000
From: Mel Gorman <mgorman@suse.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: build failure after merge of the akpm tree
Message-ID: <20121218101020.GL9887@suse.de>
References: <20121218132907.099de7f8d94e73f189b01b21@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20121218132907.099de7f8d94e73f189b01b21@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 01:29:07PM +1100, Stephen Rothwell wrote:
> Hi Andrew,
> 
> After merging the akpm tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> mm/migrate.c: In function 'migrate_misplaced_transhuge_page':
> mm/migrate.c:1738:2: error: incompatible type for argument 3 of 'update_mmu_cache_pmd'
> arch/x86/include/asm/pgtable.h:792:20: note: expected 'struct pmd_t *' but argument is of type 'pmd_t'
> 
> Caused by commit b32967ff101a ("mm: numa: Add THP migration for the NUMA
> working set scanning fault case") from Linus' tree interacting with
> commit "x86: convert update_mmu_cache() and update_mmu_cache_pmd() to
> functions".
> 
> This was previously reported as against the tip tree, but the fix patch
> (which was applied to the tip tree) did not survive the rewrite that went
> into Linus' tree.  Just a little annoyed :-(
> 

Sorry about that Stephen, I should have caught the fix in the tip tree
and picked it up. Thanks for fixing it a second time.

-- 
Mel Gorman
SUSE Labs

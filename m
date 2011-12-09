Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174Ab1LIKhM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 05:37:12 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:50641 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750844Ab1LIKhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 05:37:10 -0500
Date: Fri, 9 Dec 2011 10:36:52 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>, Russell King <rmk@arm.linux.org.uk>
Subject: Re: linux-next: manual merge of the arm-lpae tree with the arm tree
Message-ID: <20111209103652.GA23753@arm.com>
References: <20111208110059.1d88730db9358e079949b89c@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111208110059.1d88730db9358e079949b89c@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Thu, Dec 08, 2011 at 12:00:59AM +0000, Stephen Rothwell wrote:
> Today's linux-next merge of the arm-lpae tree got a conflict in
> arch/arm/mm/idmap.c between commits 8903826d0cd9 ("ARM: idmap: populate
> identity map pgd at init time using .init.text") and 4e8ee7de227e ("ARM:
> SMP: use idmap_pgd for mapping MMU enable during secondary booting") from
> the arm tree and commit 1932aa1edc86 ("ARM: LPAE: Add identity mapping
> support for the 3-level page table format") from the arm-lpae tree.
> 
> I tried to fix it up (see below) and can carry the fix as necessary.

The fix looks correct but Russell merged the LPAE patches into his tree
last night and sorted out the conflicts, so you can now drop my for-next
branch from -next (I'll still keep the kmemleak one).

Thanks.

-- 
Catalin

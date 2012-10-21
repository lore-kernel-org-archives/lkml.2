Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932324Ab2JUQ3r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 12:29:47 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:53387 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885Ab2JUQ3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 12:29:45 -0400
Date: Sun, 21 Oct 2012 18:29:40 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>
Subject: Re: linux-next: manual merge of the tip tree with Linus' tree
Message-ID: <20121021162940.GE27429@gmail.com>
References: <20121016120041.57f0bb718ca0389707dc3083@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121016120041.57f0bb718ca0389707dc3083@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi all,
> 
> Today's linux-next merge of the tip tree got a conflict in
> mm/huge_memory.c between commit 325adeb55e32 ("mm: huge_memory: Fix build
> error") from Linus' tree and commit 39d6cb39a817 ("mm/mpol: Use special
> PROT_NONE to migrate pages") from the tip tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Ok, this conflict should go away the next time you integrate 
linux-next.

Thanks,

	Ingo

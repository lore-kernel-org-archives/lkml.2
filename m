Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612Ab1KGKSY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 05:18:24 -0500
Received: from h5.dl5rb.org.uk ([81.2.74.5]:50109 "EHLO linux-mips.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753273Ab1KGKSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 05:18:23 -0500
Date: Mon, 7 Nov 2011 10:18:00 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yong Zhang <yong.zhang0@gmail.com>,
        David Daney <david.daney@cavium.com>
Subject: Re: linux-next: manual merge of the mips tree with Linus' tree
Message-ID: <20111107101800.GA28613@linux-mips.org>
References: <20111107110403.9fb12ceed80d07d9765031bb@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111107110403.9fb12ceed80d07d9765031bb@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 07, 2011 at 11:04:03AM +1100, Stephen Rothwell wrote:

> Today's linux-next merge of the mips tree got a conflict in
> arch/mips/kernel/perf_event.c between commit e5dcb58aa510 ("MIPS: perf:
> Reorganize contents of perf support files") from Linus' tree and commit
> 6e8722f887b2 ("MIPS: irq: Remove IRQF_DISABLED") from the mips tree.
> 
> The former moved the code that the latter modified and it appeasr to have
> been fixed up in its new position.  So I just used the version of this
> file that is in Linus' tree.

Time to rebase, I think.  I hope Linus is going to make an -rc1 soon.

  Ralf

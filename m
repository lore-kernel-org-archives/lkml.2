Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753037Ab2JAJqB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 05:46:01 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:57469 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458Ab2JAJqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 05:46:00 -0400
Date: Mon, 1 Oct 2012 11:45:55 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, riel@redhat.com, oleg@redhat.com,
        pjt@google.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        Lee.Schermerhorn@hp.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/19] mm/mpol: Add MPOL_MF_NOOP
Message-ID: <20121001094554.GA19112@gmail.com>
References: <20120731191204.540691987@chello.nl>
 <20120731192808.769449391@chello.nl>
 <CAHO5Pa2Ai6BzXFtTDBzuw4y=tzk9G4DA=9cRBojVjjMB9mtT0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHO5Pa2Ai6BzXFtTDBzuw4y=tzk9G4DA=9cRBojVjjMB9mtT0w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Michael Kerrisk <mtk.manpages@gmail.com> wrote:

> On Tue, Jul 31, 2012 at 9:12 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > From: Lee Schermerhorn <lee.schermerhorn@hp.com>
> >
> > This patch augments the MPOL_MF_LAZY feature by adding a 
> > "NOOP" policy to mbind().  When the NOOP policy is used with 
> > the 'MOVE and 'LAZY flags, mbind() [check_range()] will walk 
> > the specified range and unmap eligible pages so that they 
> > will be migrated on next touch.
> 
> This patch is mistitled. The new flag is MPOL_NOOP. That made 
> it difficult to find the commit in linux-next. Does it make 
> sense to fix the patch title before this hits mainline?

In isolation such a minor title problem alone does not justify 
rebasing.

Thanks,

	Ingo

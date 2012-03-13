Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267Ab2CMMRd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 08:17:33 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58767 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab2CMMRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 08:17:32 -0400
Date: Tue, 13 Mar 2012 12:17:07 +0000
From: Russell King <rmk@arm.linux.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [GIT PULL/NEXT] sched/arch: Introduce the
	finish_arch_post_lock_switch() scheduler callback
Message-ID: <20120313121707.GA2174@flint.arm.linux.org.uk>
References: <20120313083310.GA27560@flint.arm.linux.org.uk> <20120313083630.GA10131@elte.hu> <20120313084713.GB27560@flint.arm.linux.org.uk> <20120313085628.GB6991@elte.hu> <20120313090040.GE27560@flint.arm.linux.org.uk> <20120313092649.GA15406@elte.hu> <20120313095020.GA13220@flint.arm.linux.org.uk> <20120313101859.GA2626@elte.hu> <20120313112729.GA25835@flint.arm.linux.org.uk> <20120313115640.GA27378@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120313115640.GA27378@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 12:56:40PM +0100, Ingo Molnar wrote:
> Look into the fine conflict report Russell: it conflicts with 
> *Linus's* tree, because it's based off some random 
> barely-beyond-rc1 development window -rc3 base. Even at the 
> commit date of Feb 27 we had a more stable base tree available - 
> and especially when you pulled it, several weeks down the line, 
> -rc3 was not a defensible base for the integrated result.

I'm not going to ask someone to rebase their patches after they've been
fully tested on a set of platforms.  It has been stated many times that
rebasing invalidates the testing that the patches have been subjected
to, and these have been tested by several different people on a range
of platforms.

It seems what _you_ care more about is having nice clean git trees and
proper git flow at the detriment to dealing with tested changes.

The fact of the matter is that I took a set of well tested patches into
my tree which _you_ were copied on multiple times, that Peter Z. was
aware of what was happening, and which trivially conflict with some other
change which happened along the way.  Such a trivial conflict does _NOT_
justify rebasing the patch set, thereby invalidating all the testing that
has done.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:

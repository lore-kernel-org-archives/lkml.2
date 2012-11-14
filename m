Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745Ab2KNGrf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 01:47:35 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:64573 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643Ab2KNGre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 01:47:34 -0500
Date: Wed, 14 Nov 2012 07:47:26 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Linus <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Hugh Dickins <hughd@google.com>
Subject: Re: linux-next: Tree for Nov 14
Message-ID: <20121114064726.GA2537@gmail.com>
References: <20121114163042.64f0c0495663331b9c2d60d6@canb.auug.org.au>
 <20121113213742.292f3ace.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121113213742.292f3ace.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 14 Nov 2012 16:30:42 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 
> > News: next-20121115 (i.e. tomorrow) will be the last release until
> > next-20121126 (which should be just be after -rc7, I guess - assuming
> > that Linus does not release v3.7 before then), so if you want something
> > in linux-next for a reasonable amount of testing, it should probably be
> > committed tomorrow.
> 
> It would help if the old sched/numa code wasn't in -next while 
> you're away.  That would give me a clean run at 3.7 and will 
> make it easier for others to integrate and test the four(!) 
> different autoschednumacore implementations on top of 
> linux-next.
> 
> Pretty please?

The next integration should have this solved: I have removed the 
old sched/numa bits, replaced by the latest rebased/reworked 
numa/core bits.

(There's no fundamental changes to the mm/ bits, so the 
conflict/merge fall-out should be minimal and/or trivial.)

Thanks,

	Ingo

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389Ab2HUOFj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 10:05:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48914 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752011Ab2HUOFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 10:05:38 -0400
Date: Tue, 21 Aug 2012 10:05:00 -0400
From: Don Zickus <dzickus@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, mmarek@suse.cz, linux-kbuild@vger.kernel.org,
        JBeulich@suse.com, akpm@linux-foundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        jmario@redhat.com
Subject: Re: RFC: Link Time Optimization support for the kernel
Message-ID: <20120821140500.GB705@redhat.com>
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
 <20120820074835.GA6710@gmail.com>
 <20120820101044.GE16230@one.firstfloor.org>
 <20120821074921.GA10809@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120821074921.GA10809@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 09:49:21AM +0200, Ingo Molnar wrote:
> > A lot of the overhead on the larger builds is also some 
> > specific gcc code that I'm working with the gcc developers on 
> > to improve. So the 4x extreme case will hopefully go down.
> > 
> > The large builds also currently suffer from too much memory 
> > consumption. That will hopefully improve too, as gcc improves.
> 
> Are there any LTO build files left around, blowing up the size 
> of the build tree?

Hi Ingo,

Joe Mario from Red Hat has been assisting Andi with his LTO work.  One of
the ideas he had which may help here is to push the LTO granularity down
to the directory level.  This would allow subsystem maintainers to opt-in
and keep the compile overhead consistent across randconfigs as the linker
would have a smaller pool of files to deal with.

Joe was wondering if he hacked something up for the scheduler directory
only, if there was some preferred benchmark tools he could run to verify a
performance increase or not?

Cheers,
Don

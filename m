Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400Ab0EQNoZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 09:44:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12721 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752365Ab0EQNoY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 09:44:24 -0400
Date: Mon, 17 May 2010 09:44:03 -0400
From: Don Zickus <dzickus@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [GIT PULL] Lockup detector build fixes
Message-ID: <20100517134403.GU15159@redhat.com>
References: <20100515073732.GA17120@elte.hu>
 <1273977240-30800-1-git-send-regression-fweisbec@gmail.com>
 <20100516023648.GD7645@nowhere>
 <20100516075605.GA15391@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100516075605.GA15391@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 16, 2010 at 09:56:05AM +0200, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > On Sun, May 16, 2010 at 04:33:56AM +0200, Frederic Weisbecker wrote:
> > > Ingo,
> > > 
> > > Please pull the perf/nmi branch that can be found at:
> > > 
> > > git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> > > 	perf/nmi
> > > 
> > > Thanks,
> > > 	Frederic
> > 
> > 
> > Tested on x86 and Sparc 64 with and without 
> > CONFIG_LOCKUP_DETECTOR. No problem so far. Tell me 
> > if you find any.
> 
> Looks good so far. Pulled, thanks Frederic!

Thanks Frederic!

Cheers,
Don

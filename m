Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757805Ab0DARtB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 13:49:01 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:51570 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754242Ab0DARsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 13:48:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=uZM8rJjehL3lSk08+O2nFoG8rRlBto+OD9ynphmIn01ejJN28aErbu9G+KtUb1MPhE
         fukVE36Zwc11BcTWyxoAY/BRF50UO50zBrTNeR4UhmqcwmA9rbO/4zFIfYBgQ1Cv3VDK
         QxT5CArFps7/M385u3UGT52dCo8Y2eln7UikI=
Date: Thu, 1 Apr 2010 20:48:58 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: John Kacur <jkacur@gmail.com>, Roland McGrath <roland@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] ptrace: kill BKL in ptrace syscall
Message-ID: <20100401184855.GB6142@nowhere>
References: <1269812331-8511-1-git-send-regression-fweisbec@gmail.com> <20100329114046.GB16971@redhat.com> <520f0cf11003290506o629c9ab6n95c94c48ba24acf4@mail.gmail.com> <20100329130526.GA23201@redhat.com> <520f0cf11003290626q2e74c5d1r1eebb07a75e25dd5@mail.gmail.com> <20100329182204.GE5101@nowhere> <20100329183502.GA17842@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100329183502.GA17842@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 29, 2010 at 08:35:02PM +0200, Oleg Nesterov wrote:
> On 03/29, Frederic Weisbecker wrote:
> >
> > On Mon, Mar 29, 2010 at 03:26:26PM +0200, John Kacur wrote:
> > > On Mon, Mar 29, 2010 at 3:05 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> > > >
> > > > Cough. I must admit, apart from "urgent" bugfixes the only way I know
> > > > is to send the patch to Andrew.
> > > >
> > > > So I'd suggest to send this patch to akpm. Of course, if you wish I can
> > > > forward it, but doesn't matter.
> > > >
> > > I know that in the past, Thomas was keeping a BKL tree in tip, but not sure if
> > > he is still doing so. It seems that Arnd's tree is at least partially
> > > experimental,
> > > so I wonder if we need to maintain another BKL tree somewhere of fixes
> > > that have no
> > > obvious maintainer, but are ready to send to Linus for inclusion?
> >
> >
> > I have cc'ed Andrew for this patch, partly for that purpose, so that he
> > can take it if he wants to.
> 
> Ah, good, I didn't notice.
> 
> If he doesn't pick this patch now, I'll forward it to him later again ;)
> 
> > But in the worst case these patches are never lost. We don't want to lose
> > them. For those that can't go in someone else .35 targeted tree for any reason,
> > I can queue them up in mine in a dedicated branch that I'll propose to Linus.
> 
> Frederic, whatever is more convenient to you.
> 
> Oleg.
> 


I have applied it to:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	bkl/core

Thanks.


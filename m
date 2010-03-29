Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837Ab0C2ShT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 14:37:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751728Ab0C2ShR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 14:37:17 -0400
Date: Mon, 29 Mar 2010 20:35:02 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: John Kacur <jkacur@gmail.com>, Roland McGrath <roland@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] ptrace: kill BKL in ptrace syscall
Message-ID: <20100329183502.GA17842@redhat.com>
References: <1269812331-8511-1-git-send-regression-fweisbec@gmail.com> <20100329114046.GB16971@redhat.com> <520f0cf11003290506o629c9ab6n95c94c48ba24acf4@mail.gmail.com> <20100329130526.GA23201@redhat.com> <520f0cf11003290626q2e74c5d1r1eebb07a75e25dd5@mail.gmail.com> <20100329182204.GE5101@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100329182204.GE5101@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29, Frederic Weisbecker wrote:
>
> On Mon, Mar 29, 2010 at 03:26:26PM +0200, John Kacur wrote:
> > On Mon, Mar 29, 2010 at 3:05 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> > >
> > > Cough. I must admit, apart from "urgent" bugfixes the only way I know
> > > is to send the patch to Andrew.
> > >
> > > So I'd suggest to send this patch to akpm. Of course, if you wish I can
> > > forward it, but doesn't matter.
> > >
> > I know that in the past, Thomas was keeping a BKL tree in tip, but not sure if
> > he is still doing so. It seems that Arnd's tree is at least partially
> > experimental,
> > so I wonder if we need to maintain another BKL tree somewhere of fixes
> > that have no
> > obvious maintainer, but are ready to send to Linus for inclusion?
>
>
> I have cc'ed Andrew for this patch, partly for that purpose, so that he
> can take it if he wants to.

Ah, good, I didn't notice.

If he doesn't pick this patch now, I'll forward it to him later again ;)

> But in the worst case these patches are never lost. We don't want to lose
> them. For those that can't go in someone else .35 targeted tree for any reason,
> I can queue them up in mine in a dedicated branch that I'll propose to Linus.

Frederic, whatever is more convenient to you.

Oleg.


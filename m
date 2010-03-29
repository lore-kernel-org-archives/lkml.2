Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985Ab0C2SqQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 14:46:16 -0400
Received: from mail-iw0-f182.google.com ([209.85.223.182]:64605 "EHLO
	mail-iw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531Ab0C2SqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 14:46:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UWrEN0dYXJD3+oP3oAtsghmV7r0NBafBsQ0QuSu5jlmJY4cAwHjohLuy3iD8vA+V8V
         zfEE3iZRskmSO6WV4QcbmBTG58dg0/gRpZvPpo4pc+H9o5dizKdmm8bgeS5kq1KICbyu
         zoeOdsgFl16d41lza2WMzG3DTD6J0GlDajh6o=
Date: Mon, 29 Mar 2010 20:46:15 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: John Kacur <jkacur@gmail.com>, Roland McGrath <roland@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] ptrace: kill BKL in ptrace syscall
Message-ID: <20100329184613.GG5101@nowhere>
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


I just keep it somewhere and if it's not queued in one week or so, I'll put
it in my tree :-)

Thanks.


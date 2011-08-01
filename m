Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302Ab1HAVya (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 17:54:30 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:46352 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752243Ab1HAVyY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 17:54:24 -0400
Date: Mon, 1 Aug 2011 14:54:22 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: sedat.dilek@gmail.com
Cc: Sedat Dilek <sedat.dilek@googlemail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: Tree for Aug 1
Message-Id: <20110801145422.cccff7aa.rdunlap@xenotime.net>
In-Reply-To: <CA+icZUXq9V6h6kJrjckpeDXQAbQ-skiKLwTjD7Luhz1mTqSM1w@mail.gmail.com>
References: <20110801144732.7f5204b219f628f2a2a63b0c@canb.auug.org.au>
	<CA+icZUXq9V6h6kJrjckpeDXQAbQ-skiKLwTjD7Luhz1mTqSM1w@mail.gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Aug 2011 09:01:21 +0200 Sedat Dilek wrote:

> On Mon, Aug 1, 2011 at 6:47 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > Hi all,
> >
> > Just in case anyone needs reminding:  Please do not add anything destined
> > for v3.2 into linux-next included trees until after v3.1-rc1.
> >
> > The powerpc allyesconfig build (at least) fails today.
> >
> > Changes since 20110729:
> >
> > Linus' tree still lost its build failure.
> >
> > The v4l-dvb tree lost its conflicts.
> >
> > The kgdb tree gained a build failure for which I reverted 3 commits.
> >
> > The moduleh tree gained a conflict against the slabe-dma tree but lost
> > its build failures (except for a few remaining merge fixups).
> >
> > ----------------------------------------------------------------------------
> >
> 
> Just FYI: mmotm-tree still misses the fixup-patch from [1].
> 
> - Sedat -
> 
> [1] https://patchwork.kernel.org/patch/1021602/

Yes, I am applying this patch daily (among others).  :(

Acked-by: Randy Dunlap <rdunlap@xenotime.net>

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

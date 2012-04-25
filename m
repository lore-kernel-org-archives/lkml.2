Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808Ab2DYPKB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 11:10:01 -0400
Received: from casper.infradead.org ([85.118.1.10]:37726 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413Ab2DYPJ7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 11:09:59 -0400
Message-ID: <1335366582.28150.270.camel@twins>
Subject: Re: [RFC][PATCH 2/3] math128: Introduce {mult,add,cmp}_u128
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Juri Lelli <juri.lelli@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 25 Apr 2012 17:09:42 +0200
In-Reply-To: <CAMuHMdVSjX1ZRc_Q0cuL+U_f+zzuD+1cjW-OBdn1c3mC8Ya_Rg@mail.gmail.com>
References: <20120424161039.293018424@chello.nl>
	 <20120424162224.526249106@chello.nl>
	 <20120425102342.45cf5c5e81e8aeb3bec67d0b@canb.auug.org.au>
	 <1335341466.28150.248.camel@twins>
	 <CAMuHMdUqgR8Z8wtBjm=-g9ff6CVmEd=FpbC2tk-CMU7B3XVVDg@mail.gmail.com>
	 <1335355106.28150.254.camel@twins>
	 <CAMuHMdVSjX1ZRc_Q0cuL+U_f+zzuD+1cjW-OBdn1c3mC8Ya_Rg@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-04-25 at 16:35 +0200, Geert Uytterhoeven wrote:
> On Wed, Apr 25, 2012 at 13:58, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> >> Still using quilt? I didn't regret ditching it in favor of git (yummy,
> >> git rebase ;-).
> >
> > Yeah, I can't seem to deal with git, I edit my patches by hand way too
> > often, also quilt is a _LOT_ faster pushing/popping patches than git is
> > (and yes I use an SSD).
> >
> > Not using git also means I don't have to deal with the trainwreck that
> > is git-merge,.. /me runs like hell.
> 
> But you have to deal with the quilt-oh-no-the-patch-no-longer-applies
> trainwreck...

Yeah, but I find it much easier to deal with .rej files than with the
stuff left behind by git.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297Ab2EXHW4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 03:22:56 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:35713 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013Ab2EXHWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 03:22:54 -0400
Date: Thu, 24 May 2012 09:22:48 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree
Message-ID: <20120524072248.GB16738@gmail.com>
References: <20120521185412.aca92107d0a8c4fdd8474e34@canb.auug.org.au>
 <20120521091257.GF31407@gmail.com>
 <20120522182542.655b939d96a8eb67390abb9a@canb.auug.org.au>
 <20120523153536.GD26974@gmail.com>
 <20120524171604.0d98284f3affc643e9714470@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120524171604.0d98284f3affc643e9714470@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Ingo,
> 
> On Wed, 23 May 2012 17:35:36 +0200 Ingo Molnar <mingo@kernel.org> wrote:
> >
> > * Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > 
> > > On Mon, 21 May 2012 11:12:57 +0200 Ingo Molnar <mingo@kernel.org> wrote:
> > > >
> > > > * Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > > > 
> > > > > After merging the final tree, today's linux-next build (i386 defconfig)
> > > > > failed like this:
> > > > > 
> > > > > Invalid absolute R_386_32 relocation: jiffies
> > > > 
> > > > Hm, that's our fault: seems like a linker bug fallout, one which 
> > > > we fixed in -tip.
> > > > 
> > > > > I am not sure what caused this (it may even been a bad merge 
> > > > > on my part).  I have left it broken for today.
> > > > 
> > > > While we've fixed this, to simplify merge window integration of 
> > > > linux-next I've excluded tip:x86/trampoline from the linux-next 
> > > > branch for now, so this build failure should go away tomorrow.
> > > 
> > > Weirdly, I still got the same error today.  Any ideas?
> > 
> > Ought to be fixed now.
> 
> OK, clearly something is wrong :-( There could well be a 
> problem with my toolchain.
> 
> I am still getting this error.  Build is an i386 defconfig

Hm, Peter?

Thanks,

	Ingo

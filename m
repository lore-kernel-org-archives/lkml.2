Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478Ab1LIEmL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 23:42:11 -0500
Received: from gate.crashing.org ([63.228.1.57]:48909 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750854Ab1LIEmJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 23:42:09 -0500
Message-ID: <1323405702.19891.7.camel@pasglop>
Subject: Re: linux-next: manual merge of the 4xx tree with the powerpc tree
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Josh Boyer <jwboyer@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, Tanmay Inamdar <tinamdar@apm.com>
Date: Fri, 09 Dec 2011 15:41:42 +1100
In-Reply-To: <CA+5PVA5vVC=e24imM0QxbT10kBAF4v=kwheKs7cOHKKcC+if=A@mail.gmail.com>
References: <20111209123811.12cf28971f21a309976f31bb@canb.auug.org.au>
	 <CA+5PVA5vVC=e24imM0QxbT10kBAF4v=kwheKs7cOHKKcC+if=A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-08 at 20:46 -0500, Josh Boyer wrote:
> On Thu, Dec 8, 2011 at 8:38 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > Hi Josh,
> >
> > Today's linux-next merge of the 4xx tree got a conflict in
> > arch/powerpc/platforms/40x/ppc40x_simple.c between commit 11eab297f57b
> > ("powerpc: Add support for OpenBlockS 600") from the powerpc tree and
> > commit d5b9ee7b514e ("powerpc/40x: Add APM8018X SOC support") from the
> > 4xx tree.
> 
> I blame BenH.  I sent him a pull request with d5b9ee7b514e in it
> before he went and updated his tree.  Still not pulled afaik.  Guess
> I'll be rebasing my next branch tomorrow to pick up a series from Tony
> Breeds, unless Ben handles the outstanding pull before I wake up :).

Don't bother rebasing, I can deal with a minor merge conflict like
that :-)

> > I fixed it up (see below) and can carry the fix as necessary.
> 
> Looks correct to me.  Hopefully you won't have to carry it long.
> >
> > [Josh: I have changed you contact address to the above]

Cheers,
Ben.



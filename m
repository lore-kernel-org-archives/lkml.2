Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410Ab2C1AYK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 20:24:10 -0400
Received: from mail.windriver.com ([147.11.1.11]:33798 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757254Ab2C1AYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 20:24:07 -0400
Date: Tue, 27 Mar 2012 20:23:59 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Mike Frysinger <vapier.adi@gmail.com>, Bob Liu <lliubbo@gmail.com>
Subject: Re: Blackfin link issue (Was: linux-next: triage for March 27, 2012)
Message-ID: <20120328002359.GA12442@windriver.com>
References: <20120327213626.GA10022@windriver.com>
 <20120328110350.e2d44e1f66b6ac7f9fd82843@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120328110350.e2d44e1f66b6ac7f9fd82843@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Blackfin link issue (Was: linux-next: triage for March 27, 2012)] On 28/03/2012 (Wed 11:03) Stephen Rothwell wrote:

> Hi Paul,
> 
> On Tue, 27 Mar 2012 17:36:27 -0400 Paul Gortmaker <paul.gortmaker@windriver.com> wrote:
> >
> > The blackfin builds are no longer failing on vm_is_stack but instead
> > are all failing with "L1 data A overflow!" at final link, which smells
> > like some kind of binutils/toolchain issue.
> > 
> > 
> > bfin:***all-builds***
> > 	when:	Mar 26
> > 	why:	bfin-uclinux-ld: L1 data A overflow!
> > 	status:	unknown, binutils issue?
> > 	fix:
> > 	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/5981475/
> 
> It actually looks like this comes from an ASSERT in the blackfin
> vmlinux.lds.S ... looks like some sections overflowed.

Thanks Stephen -- I see you've CC'd some blackfin folks -- lets hope
they can help shed some light on this.  I'll admit my guess above
was only that --- just a guess.

Paul.
--

> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au



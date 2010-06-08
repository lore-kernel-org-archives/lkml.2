Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522Ab0FHGex (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 02:34:53 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:59453 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918Ab0FHGew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 02:34:52 -0400
Date: Tue, 8 Jun 2010 15:34:19 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: David Rientjes <rientjes@google.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frans Pop <elendil@planet.nl>, Dirk Hohndel <hohndel@infradead.org>,
       Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, v2] kbuild: Improve version string logic - two for the price of one - No thanks
Message-ID: <20100608063419.GF6376@linux-sh.org>
References: <alpine.LFD.2.01.0910060815320.3432@localhost.localdomain> <20091006153632.GA29795@elte.hu> <alpine.LFD.2.01.0910060843560.3432@localhost.localdomain> <alpine.LFD.2.01.0910060925490.3432@localhost.localdomain> <20091006173508.GA4786@elte.hu> <20091012195733.GA7351@elte.hu> <4C0D29DE.6050602@panasas.com> <alpine.DEB.2.00.1006071242510.30389@chino.kir.corp.google.com> <4C0DDAA6.8080002@panasas.com> <alpine.DEB.2.00.1006072311170.31780@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1006072311170.31780@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 07, 2010 at 11:18:42PM -0700, David Rientjes wrote:
> On Tue, 8 Jun 2010, Boaz Harrosh wrote:
> 
> > >> I already have my:
> > >>  VERSION = 2
> > >>  PATCHLEVEL = 6
> > >>  SUBLEVEL = 35
> > >> -EXTRAVERSION = -rc2
> > >> +EXTRAVERSION = -rc2-my_tree
> > >>
> > > 
> > > You shouldn't be using EXTRAVERSION for this purpose, you should be 
> > > passing LOCALVERSION=my_tree to make.
> > > 
> > 
> > That will not work because the way I run make is out of my control. Every
> > one in the working group has his system. The Makefile is part of the
> > public git tree, so every one will get the same identification without
> > any confusion with Vanilla kernel, or what was compiled.
> > 
> 
> If everyone using that tree wants the same version string for that kernel, 
> use CONFIG_LOCALVERSION="-my_tree" in your .config and use "make 
> LOCALVERSION=".
> 
Or just distribute a localversion-my_tree file in the top-level directory
like other trees do. This doesn't strike me as a particularly significant
problem.

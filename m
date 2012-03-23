Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757650Ab2CWTz0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 15:55:26 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:61380 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756446Ab2CWTzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 15:55:25 -0400
Date: Fri, 23 Mar 2012 20:55:20 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86/kconfig: Update defconfigs
Message-ID: <20120323195520.GA7222@gmail.com>
References: <tip-ahz3d8i1vxwj0379gv4tqcru@git.kernel.org>
 <4F6CD38B.1010602@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F6CD38B.1010602@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Randy Dunlap <rdunlap@xenotime.net> wrote:

> On 03/23/2012 12:43 PM, tip-bot for Ingo Molnar wrote:
> 
> > Commit-ID:  280fb016bfb098f33df96016cfaa840db77ba2d0
> > Gitweb:     http://git.kernel.org/tip/280fb016bfb098f33df96016cfaa840db77ba2d0
> > Author:     Ingo Molnar <mingo@kernel.org>
> > AuthorDate: Fri, 23 Mar 2012 13:12:38 +0100
> > Committer:  Ingo Molnar <mingo@kernel.org>
> > CommitDate: Fri, 23 Mar 2012 13:14:53 +0100
> > 
> > x86/kconfig: Update defconfigs
> > 
> > Link: http://lkml.kernel.org/n/tip-ahz3d8i1vxwj0379gv4tqcru@git.kernel.org
> > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > ---
> >  arch/x86/configs/i386_defconfig   |   65 ++++++++++++-----------------------
> >  arch/x86/configs/x86_64_defconfig |   68 +++++++++++++------------------------
> >  2 files changed, 47 insertions(+), 86 deletions(-)
> > 
> > diff --git a/arch/x86/configs/i386_defconfig b/arch/x86/configs/i386_defconfig
> > index 2bf18059f..2d56282 100644
> > --- a/arch/x86/configs/i386_defconfig
> > +++ b/arch/x86/configs/i386_defconfig
> > -CONFIG_TR=y
> > +CONFIG_TR=y
> 
> 
> 
> > diff --git a/arch/x86/configs/x86_64_defconfig b/arch/x86/configs/x86_64_defconfig
> > index 058a35b..3cf137a 100644
> > --- a/arch/x86/configs/x86_64_defconfig
> > +++ b/arch/x86/configs/x86_64_defconfig
> > -CONFIG_TR=y
> > +CONFIG_TR=y
> 
> 
> Hmph.  On 2009-oct-20, I sent a patch to disable CONFIG_TR 
> from these defconfigs.  I still think that should be done.

Yeah, now that the defconfigs are much smaller we can do such 
things. Mind resending the patch and possibly checking all the 
other options as well?

Thanks,

	Ingo

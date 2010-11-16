Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932844Ab0KPWCR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 17:02:17 -0500
Received: from tundra.namei.org ([65.99.196.166]:42169 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932124Ab0KPWCO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 17:02:14 -0500
Date: Wed, 17 Nov 2010 09:01:40 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Eric Paris <eparis@redhat.com>
cc: Joe Perches <joe@perches.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dan Rosenberg <drosenberg@vsecurity.com>, Ingo Molnar <mingo@elte.hu>,
        Eugene Teo <eugeneteo@kernel.org>, Kees Cook <kees.cook@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/sysctl.c: Fix build failure with !CONFIG_PRINTK
In-Reply-To: <1289885773.14282.57.camel@localhost.localdomain>
Message-ID: <alpine.LRH.2.00.1011170901210.8177@tundra.namei.org>
References: <201011160259.oAG2x1UX012045@hera.kernel.org>  <1289884647.16461.186.camel@Joe-Laptop> <1289885773.14282.57.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Nov 2010, Eric Paris wrote:

> On Mon, 2010-11-15 at 21:17 -0800, Joe Perches wrote:
> > Sigh...
> > 
> > Signed-off-by: Joe Perches <joe@perches.com>
> 
> eparis fails again.
> 
> Acked-by: Eric Paris <eparis@redhat.com>

Acked-by: James Morris <jmorris@namei.org>


> 
> > ---
> >  kernel/sysctl.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> > index b65bf63..5abfa15 100644
> > --- a/kernel/sysctl.c
> > +++ b/kernel/sysctl.c
> > @@ -702,7 +702,6 @@ static struct ctl_table kern_table[] = {
> >  		.extra1		= &zero,
> >  		.extra2		= &ten_thousand,
> >  	},
> > -#endif
> >  	{
> >  		.procname	= "dmesg_restrict",
> >  		.data		= &dmesg_restrict,
> > @@ -712,6 +711,7 @@ static struct ctl_table kern_table[] = {
> >  		.extra1		= &zero,
> >  		.extra2		= &one,
> >  	},
> > +#endif
> >  	{
> >  		.procname	= "ngroups_max",
> >  		.data		= &ngroups_max,
> > 
> > 
> 
> 

-- 
James Morris
<jmorris@namei.org>

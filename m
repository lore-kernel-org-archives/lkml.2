Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757136Ab1JOAkQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 20:40:16 -0400
Received: from tundra.namei.org ([65.99.196.166]:35714 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755070Ab1JOAkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 20:40:15 -0400
Date: Sat, 15 Oct 2011 11:40:12 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Casey Schaufler <casey@schaufler-ca.com>
cc: Jarkko Sakkinen <jarkko.j.sakkinen@gmail.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH] Smack: compilation fix
In-Reply-To: <4E985DA8.80608@schaufler-ca.com>
Message-ID: <alpine.LRH.2.00.1110151140050.24994@tundra.namei.org>
References: <1318587384-2737-1-git-send-email-jarkko.j.sakkinen@gmail.com> <4E985DA8.80608@schaufler-ca.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Oct 2011, Casey Schaufler wrote:

> On 10/14/2011 3:16 AM, Jarkko Sakkinen wrote:
> > On some build configurations PER_CLEAR_ON_SETID symbol was not
> > found when compiling smack_lsm.c. This patch fixes the issue by
> > explicitly doing #include <linux/personality.h>.
> >
> > Signed-off-by: Jarkko Sakkinen <jarkko.j.sakkinen@gmail.com>
> 
> Applied to git://gitorious.org/smack-next/kernel.git#master
> 
> James, can you pull for security testing please?

Pulled.

> 
> commit 16014d87509e26d6ed6935adbbf437a571fb5870
> 
> > ---
> >  security/smack/smack_lsm.c |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> >
> > diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> > index d55b991..7db62b4 100644
> > --- a/security/smack/smack_lsm.c
> > +++ b/security/smack/smack_lsm.c
> > @@ -35,6 +35,7 @@
> >  #include <linux/audit.h>
> >  #include <linux/magic.h>
> >  #include <linux/dcache.h>
> > +#include <linux/personality.h>
> >  #include "smack.h"
> >  
> >  #define task_security(task)	(task_cred_xxx((task), security))
> 

-- 
James Morris
<jmorris@namei.org>

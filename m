Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755773Ab1FRPDy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 11:03:54 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:53343 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264Ab1FRPDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 11:03:52 -0400
Date: Sat, 18 Jun 2011 11:03:35 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost6.localdomain6
To: Randy Dunlap <rdunlap@xenotime.net>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, hughd@google.com
Subject: Re: [PATCH] TMPFS: Expand "help" to explain value of
 TMPFS_POSIX_ACL
In-Reply-To: <20110618075301.b4d3816c.rdunlap@xenotime.net>
Message-ID: <alpine.DEB.2.02.1106181102550.3659@localhost6.localdomain6>
References: <alpine.DEB.2.02.1106180743040.17576@localhost6.localdomain6> <20110618075301.b4d3816c.rdunlap@xenotime.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Jun 2011, Randy Dunlap wrote:

> On Sat, 18 Jun 2011 07:45:35 -0400 (EDT) Robert P. J. Day wrote:
>
> >
> > Expand the fs/Kconfig "help" info to clarify why it's a bad idea to
> > deselect the TMPFS_POSIX_ACL config variable.
> >
> > Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
> >
> > ---
> >
> > diff --git a/fs/Kconfig b/fs/Kconfig
> > index 19891aa..4217543 100644
> > --- a/fs/Kconfig
> > +++ b/fs/Kconfig
> > @@ -127,14 +127,20 @@ config TMPFS_POSIX_ACL
> >  	select TMPFS_XATTR
> >  	select GENERIC_ACL
> >  	help
> > -	  POSIX Access Control Lists (ACLs) support permissions for users and
> > -	  groups beyond the owner/group/world scheme.
> > +	  POSIX Access Control Lists (ACLs) support additional access rights
> > +	  for users and groups beyond the standard owner/group/world scheme,
> > +	  and this option selects support for ACLs specifically for tmpfs
> > +	  filesystems.
> > +
> > +	  If you've selected TMPFS, you almost certainly want this option
> > +	  as well since a number of user space features (ie., ALSA sound)
>
> 	                                                 e.g.,
> ?
>
> Otherwise, looks good to me.
> Thanks.

  oops, i can submit a V2 patch that changes that.  or you can hack
what i submitted.  either way works for me.

rday

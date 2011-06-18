Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920Ab1FRPFZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 11:05:25 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:36201 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752773Ab1FRPFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 11:05:24 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=OG/qyJyxsiZREX8QUPn6GXcFy2Wig1eSKQNtpozg8lMHuBPY0Rv/+xxeng+E4dg0g4EtyK3xmk9F2tRgdVydEG13yHpu+baXUUX4QRPpx0EAZOAnWdkE3R+bJSQx9Vli;
Date: Sat, 18 Jun 2011 08:05:22 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, hughd@google.com
Subject: Re: [PATCH] TMPFS: Expand "help" to explain value of
 TMPFS_POSIX_ACL
Message-Id: <20110618080522.c3992e50.rdunlap@xenotime.net>
In-Reply-To: <alpine.DEB.2.02.1106181102550.3659@localhost6.localdomain6>
References: <alpine.DEB.2.02.1106180743040.17576@localhost6.localdomain6>
	<20110618075301.b4d3816c.rdunlap@xenotime.net>
	<alpine.DEB.2.02.1106181102550.3659@localhost6.localdomain6>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Jun 2011 11:03:35 -0400 (EDT) Robert P. J. Day wrote:

> On Sat, 18 Jun 2011, Randy Dunlap wrote:
> 
> > On Sat, 18 Jun 2011 07:45:35 -0400 (EDT) Robert P. J. Day wrote:
> >
> > >
> > > Expand the fs/Kconfig "help" info to clarify why it's a bad idea to
> > > deselect the TMPFS_POSIX_ACL config variable.
> > >
> > > Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
> > >
> > > ---
> > >
> > > diff --git a/fs/Kconfig b/fs/Kconfig
> > > index 19891aa..4217543 100644
> > > --- a/fs/Kconfig
> > > +++ b/fs/Kconfig
> > > @@ -127,14 +127,20 @@ config TMPFS_POSIX_ACL
> > >  	select TMPFS_XATTR
> > >  	select GENERIC_ACL
> > >  	help
> > > -	  POSIX Access Control Lists (ACLs) support permissions for users and
> > > -	  groups beyond the owner/group/world scheme.
> > > +	  POSIX Access Control Lists (ACLs) support additional access rights
> > > +	  for users and groups beyond the standard owner/group/world scheme,
> > > +	  and this option selects support for ACLs specifically for tmpfs
> > > +	  filesystems.
> > > +
> > > +	  If you've selected TMPFS, you almost certainly want this option
> > > +	  as well since a number of user space features (ie., ALSA sound)
> >
> > 	                                                 e.g.,
> > ?
> >
> > Otherwise, looks good to me.
> > Thanks.
> 
>   oops, i can submit a V2 patch that changes that.  or you can hack
> what i submitted.  either way works for me.

Please submit a v2 patch and cc: akpm on it since he will probably merge it.

thanks,
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

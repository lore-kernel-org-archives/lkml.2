Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757835Ab2CSPu2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 11:50:28 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42867 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756861Ab2CSPu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 11:50:26 -0400
Date: Mon, 19 Mar 2012 08:50:22 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Pavel Shilovsky <piastry@etersoft.ru>
Cc: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jeff Layton <jlayton@redhat.com>, Steve French <sfrench@us.ibm.com>
Subject: Re: [ 10/41] CIFS: Do not kmalloc under the flocks spinlock
Message-ID: <20120319155022.GC8176@kroah.com>
References: <20120316233829.GA14022@kroah.com>
 <20120316233811.484341257@linuxfoundation.org>
 <20120317023740.GH12704@decadent.org.uk>
 <CAKywueTUH_Zrh7iD_zsyvtmLt9O2dbd_KNrzNWzFQm4z8ZtbcQ@mail.gmail.com>
 <1331969567.3022.233.camel@deadeye>
 <CAKywueQoKN51mea7TkpT3WS=Vgj5ijNn1pOSb3cC=UZ9vVu6dw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKywueQoKN51mea7TkpT3WS=Vgj5ijNn1pOSb3cC=UZ9vVu6dw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 17, 2012 at 11:52:24AM +0400, Pavel Shilovsky wrote:
> 17 марта 2012 г. 11:32 пользователь Ben Hutchings <ben@decadent.org.uk> написал:
> > On Sat, 2012-03-17 at 10:14 +0400, Pavel Shilovsky wrote:
> >> 17 марта 2012 г. 6:37 пользователь Ben Hutchings <ben@decadent.org.uk> написал:
> >> > On Fri, Mar 16, 2012 at 04:38:20PM -0700, Greg KH wrote:
> >> >> 3.2-stable review patch.  If anyone has any objections, please let me know.
> > [...]
> >> > But we test this before flock->fl_flags & FL_POSIX, which means we
> >> > don't know whether this lock actually needs to be assigned one of
> >> > those structures.  So it appears that we might report a spurious error
> >> > if the lock list ends with a mandatory lock.  If so, this is
> >> > relatively harmless but does need to be fixed.
> >> >
> >>
> >> You are right here, thanks for the catch! I will repost the patch asap.
> >
> > This has already been merged into Linus's tree, so you need to submit a
> > patch to apply on top of it.
> >
> 
> I posted two patches:
> 1) the whole fixed version for the stable tree [PATCH v2] CIFS: Do not
> kmalloc under the flocks spinlock

What do you mean by "fixed version"?

> 2) fixup for mainline [PATCH] CIFS: Fix a spurious error in
> cifs_push_posix_locks

What do you mean by this?

If there was a follow-on patch in Linus's tree that fixes a problem, I
need that git commit id, not a "fixed" patch that does not match up with
what is in Linus's tree right now.

So, if that's the case, please let me know what the git commit id of
that patch is please.

thanks,

greg k-h

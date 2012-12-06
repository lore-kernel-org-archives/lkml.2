Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422797Ab2LFURc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 15:17:32 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51491 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167Ab2LFUR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 15:17:29 -0500
Date: Thu, 6 Dec 2012 12:17:24 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com, Michal Marek <mmarek@suse.cz>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: Re: [PATCH 036/270] kbuild: Do not package /boot and /lib in make
 tar-pkg
Message-ID: <20121206201724.GB10874@kroah.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
 <1353949160-26803-37-git-send-email-herton.krzesinski@canonical.com>
 <1353983187.4266.40.camel@deadeye.wl.decadent.org.uk>
 <20121130013843.GB13478@kroah.com>
 <1354241989.7995.26.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354241989.7995.26.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2012 at 02:19:49AM +0000, Ben Hutchings wrote:
> On Thu, 2012-11-29 at 17:38 -0800, Greg Kroah-Hartman wrote:
> > On Tue, Nov 27, 2012 at 02:26:27AM +0000, Ben Hutchings wrote:
> > > On Mon, 2012-11-26 at 14:55 -0200, Herton Ronaldo Krzesinski wrote:
> > > > 3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.
> > > > 
> > > > ------------------
> > > > 
> > > > From: Michal Marek <mmarek@suse.cz>
> > > > 
> > > > commit fe04ddf7c2910362f3817c8156e41cbd6c0ee35d upstream.
> > > > 
> > > > There were reports of users destroying their Fedora installs by a kernel
> > > > tarball that replaces the /lib -> /usr/lib symlink. Let's remove the
> > > > toplevel directories from the tarball to prevent this from happening.
> > > > 
> > > > Reported-by: Andi Kleen <andi@firstfloor.org>
> > > > Suggested-by: Ben Hutchings <ben@decadent.org.uk>
> > > > Signed-off-by: Michal Marek <mmarek@suse.cz>
> > > > [ herton: dropped unrelated changes to arch/x86/Makefile and
> > > >   scripts/Makefile.fwinst, which don't apply anyway on 3.5, see commit
> > > >   3ce9e53e788881da0d5f3912f80e0dd6b501f304 upstream ]
> > > > Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
> > > 
> > > This is missing from 3.4.
> > 
> > I don't think it is needed, as 3ce9e53e788881da0d5f3912f80e0dd6b501f304
> > didn't go into 3.4, so all should be good for now.
> 
> No, 3ce9e53e788881da0d5f3912f80e0dd6b501f304 was later and reverted
> unintended changes in fe04ddf7c2910362f3817c8156e41cbd6c0ee35d.  You
> should probably combine the two.
> 
> See these stable commits:
> 
> 3.2: 0767530 kbuild: Do not package /boot and /lib in make tar-pkg
> 3.6: 4bb50fa kbuild: Do not package /boot and /lib in make tar-pkg
> 3.6: 0a7f602 kbuild: Fix accidental revert in commit fe04ddf

Ah, thanks, that makes more sense, I think I have it straightened out
now.

greg k-h

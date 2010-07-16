Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966211Ab0GPVGB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 17:06:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36376 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966094Ab0GPVGA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 17:06:00 -0400
Date: Fri, 16 Jul 2010 17:05:40 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Ian Kent <raven@themaw.net>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 21/38] union-mount: Support for mounting union mount file systems
Message-ID: <20100716210539.GE21201@shell>
References: <1276627208-17242-1-git-send-email-vaurora@redhat.com> <1276627208-17242-22-git-send-email-vaurora@redhat.com> <20100713044701.GF3949@zeus.themaw.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100713044701.GF3949@zeus.themaw.net>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 13, 2010 at 12:47:02PM +0800, Ian Kent wrote:
> On Tue, Jun 15, 2010 at 11:39:51AM -0700, Valerie Aurora wrote:
> > +/**
> > + * prepare_mnt_union - do setup necessary for a union mount
> > + *
> > + * @topmost_mnt: vfsmount of topmost layer
> > + * @mntpnt: path of requested mountpoint
> > + *
> > + * A union mount clones the underlying read-only mounts and keeps them
> > + * in its own internal list of of vfsmounts, hanging off the
> > + * superblock.  The first underlying mount (at @mntpnt) has passed
> > + * check_mnt_union(), so we know we have at least one layer of union
> > + * mount underneath this one.  We union every underlying file system
> > + * that is mounted on the same mountpoint (well, pathname) and
> > + * read-only.
> 
> Last sentence looks a bit odd, would this be better?
> 
> We union every underlying file system that is mounted read-only on the
> same mountpoint (well, pathname).

Hm, I appear to have re-written that in the latest set of patches.

-VAL

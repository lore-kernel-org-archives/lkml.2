Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932138Ab1BWJXj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 04:23:39 -0500
Received: from ist.d-labs.de ([213.239.218.44]:34507 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755365Ab1BWJXg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 04:23:36 -0500
Date: Wed, 23 Feb 2011 10:23:14 +0100
From: Florian Mickler <florian@mickler.org>
To: Miklos Szeredi <mszeredi@suse.cz>
Cc: Tejun Heo <tj@kernel.org>, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, kovariadam@gmail.com
Subject: Re: FUSE triggering BUG through blkdev_put()
Message-ID: <20110223102314.129aac51@schatten.dmk.lab>
In-Reply-To: <1297695340.19726.294.camel@tucsk.pomaz.szeredi.hu>
References: <20110214105659.GB18742@htj.dyndns.org>
	<1297695340.19726.294.camel@tucsk.pomaz.szeredi.hu>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Feb 2011 15:55:40 +0100
Miklos Szeredi <mszeredi@suse.cz> wrote:

> On Mon, 2011-02-14 at 11:56 +0100, Tejun Heo wrote:
> > Please take a look at the following bug.
> > 
> >  https://bugzilla.kernel.org/show_bug.cgi?id=28642
> > 
> > The bug title and description are completely misleading but the
> > problem seems to have been caused by the recent eviction related
> > changes.  FUSE ends up blkdev_put'ting while I_CLEAR is still set on
> > the blkdev's inode triggering BUG_ON() in iput().
> 
> Thanks for forwarding.
> 
> It doesn't look to me that it's related to changes in fuse inode
> eviction.  More likely something from the recent inode locking changes.
> 
> Thanks,
> Miklos
> 

The Fuse Bug has nothing to do with the invisible battery of bug
28642. To avoid confusion, the fuse bug is tracked here:
https://bugzilla.kernel.org/show_bug.cgi?id=29202

Regards,
Flo

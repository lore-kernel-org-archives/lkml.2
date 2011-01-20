Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788Ab1ATQAr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 11:00:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52464 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753880Ab1ATQAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 11:00:45 -0500
Date: Thu, 20 Jan 2011 07:52:28 -0800
From: Greg KH <gregkh@suse.de>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, Tejun Heo <tj@kernel.org>,
        Ruslan Pisarev <ruslan@rpisarev.org.ua>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pohmelfs/dir.c: Remove unneeded mutex_unlock() from
 pohmelfs_rename()
Message-ID: <20110120155228.GB28815@suse.de>
References: <40908.91.79.118.36.1295471624.squirrel@mail.ispras.ru>
 <20110120105113.GA24827@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110120105113.GA24827@ioremap.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 20, 2011 at 01:51:13PM +0300, Evgeniy Polyakov wrote:
> On Thu, Jan 20, 2011 at 12:13:44AM +0300, Alexey Khoroshilov (khoroshilov@ispras.ru) wrote:
> > I do not see any reason for the mutex_unlock(&inode->i_mutex); in
> > pohmelfs_rename().
> > 
> > 
> > Found by Linux Driver Verification project (linuxtesting.org).
> 
> Yes, that's a bug, we already unlocked i_mutex in common path and should
> not do that on error.
> 
> Thank you. Greg, please apply.
> 
> > Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> 
> Acked-by: Evgeniy Polyakov <zbr@ioremap.net>

Great, I'll queue it up with the next round of patches.

greg k-h

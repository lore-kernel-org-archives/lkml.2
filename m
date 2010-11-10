Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014Ab0KJSkk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 13:40:40 -0500
Received: from kroah.org ([198.145.64.141]:46743 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754957Ab0KJSkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 13:40:08 -0500
Date: Wed, 10 Nov 2010 10:40:29 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dan Carpenter <error27@gmail.com>,
        Stephen Hemminger <stephen.hemminger@vyatta.com>
Subject: Re: linux-next: manual merge of the staging tree with the
	staging.current tree
Message-ID: <20101110184029.GC15089@kroah.com>
References: <20101110132420.fe81e1b0.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101110132420.fe81e1b0.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 01:24:20PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging tree got a conflict in
> drivers/staging/bcm/Bcmchar.c between commit
> eccbf04a904fc99c54ab37c29a2a4dedcec66e33 ("Staging: bcm: use get_user()
> to access user pointers") from the staging.current tree and commit
> ada692b09f4707a8e06b087b1546d9f5b3f2d37d ("beceem: fix character device
> ioctl") from the staging tree.
> 
> I just assumed that the latter supercedes the former and so used the
> staging version of the file.  I may well be wrong in this.

That sounds correct, I'll handle the merge when the patches go to Linus.

thanks,

greg k-h

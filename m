Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425Ab1AGWjt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 17:39:49 -0500
Received: from kroah.org ([198.145.64.141]:47473 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808Ab1AGWjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 17:39:47 -0500
Date: Fri, 7 Jan 2011 14:39:42 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>, Joe Perches <joe@perches.com>
Subject: Re: linux-next: manual merge of the staging tree with the fbdev
 tree
Message-ID: <20110107223942.GA19793@kroah.com>
References: <20110107133511.bcfc1e85.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110107133511.bcfc1e85.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 07, 2011 at 01:35:11PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging tree got a conflict in
> drivers/video/udlfb.c between commit realloc_framebuffer ("video: udlfb:
> Kill off special printk wrappers, use pr_fmt()") from the fbdev tree and
> commit 5b84cc781058bb452f869d84bb24442ec51948c4 ("staging: Use vzalloc")
> from the staging tree.
> 
> Another commit in the fbdev tree moves this file out of staging (from
> drivers/staging/udlfb/udlfb.c).
> 
> I fixed it up (see below) and can carry the fix as necessary.

Patch looks good to me, thanks for doing this.

greg k-h

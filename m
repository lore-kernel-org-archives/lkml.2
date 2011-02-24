Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756323Ab1BXTjy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 14:39:54 -0500
Received: from kroah.org ([198.145.64.141]:45096 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755899Ab1BXTjw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 14:39:52 -0500
Date: Thu, 24 Feb 2011 11:39:47 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Amit Shah <amit.shah@redhat.com>
Subject: Re: linux-next: manual merge of the tty tree with Linus' tree
Message-ID: <20110224193947.GA15044@kroah.com>
References: <20110224163439.05352f9b.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110224163439.05352f9b.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 24, 2011 at 04:34:39PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the tty tree got a conflict in
> drivers/char/Makefile between commit
> 51df0acc3d76cf41d5496ef044cc5717ab5c7f71 ("virtio: console: Move file
> back to drivers/char/") from Linus' tree and commit
> a6afd9f3e819de4795fcd356e5bfad446e4323f2 ("tty: move a number of tty
> drivers from drivers/char/ to drivers/tty/") (and later ones) from the tty
> tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.

Thanks, I've merge 2.6.38-rc6 into tty-next so this, and another merge
issue, should now be resolved.

greg k-h

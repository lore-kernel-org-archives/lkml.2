Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022Ab0EQSU0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 14:20:26 -0400
Received: from kroah.org ([198.145.64.141]:34173 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754901Ab0EQSUX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 14:20:23 -0400
Date: Mon, 17 May 2010 11:01:30 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Henk de Groot <henk.de.groot@hetnet.nl>,
       Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: linux-next: manual merge of the staging-next tree with the
 pcmcia tree
Message-ID: <20100517180130.GC16419@kroah.com>
References: <20100517154919.535f12a1.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100517154919.535f12a1.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 17, 2010 at 03:49:19PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging-next tree got a conflict in
> drivers/staging/wlags49_h2/wl_cs.c between commit
> eb14120f743d29744d9475bffec56ff4ad43a749 ("pcmcia: re-work
> pcmcia_request_irq()") from the pcmcia tree and commit
> 93822ad193f1b1d92422dc3d539456acbe1a85ef ("Staging: wlags49_hs2: Fix
> wlags49_hs2 driver after build fixes broke it") from the staging-next
> tree.
> 
> I fixed it up (see below - basically the staging-next version) and can
> carry the fix as necessary.

Looks good to me, thanks.

greg k-h

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111Ab0HBWbY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 18:31:24 -0400
Received: from kroah.org ([198.145.64.141]:36624 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753339Ab0HBWbM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 18:31:12 -0400
Date: Mon, 2 Aug 2010 15:23:46 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Gustavo Silva <silvagustavosilva@gmail.com>
Subject: Re: linux-next: manual merge of the staging-next tree with the
 pcmcia tree
Message-ID: <20100802222346.GB26966@kroah.com>
References: <20100802135740.bfdfc58c.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100802135740.bfdfc58c.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 02, 2010 at 01:57:40PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging-next tree got a conflict in
> drivers/staging/comedi/drivers/quatech_daqp_cs.c between commit
> 9b3efec734d2d79d82a6f5cef25a618d41a6b2c5 ("pcmcia: do not use io_req_t
> after call to pcmcia_request_io()") from the pcmcia tree and commit
> 3420f6b4c1ac731e80d0911e0092705992cef14f ("Staging: comedi: drivers: fix
> coding style issues in quatech_daqp_cs.c") from the staging-next tree.
> 
> Just context changes.  I fixed it up (see below) and can carry the fixes
> as necessary.

Those fixes are fine.

thanks,

greg k-h

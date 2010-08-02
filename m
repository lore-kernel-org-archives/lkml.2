Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882Ab0HBWbN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 18:31:13 -0400
Received: from kroah.org ([198.145.64.141]:36618 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751979Ab0HBWbL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 18:31:11 -0400
Date: Mon, 2 Aug 2010 15:23:35 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Prashant P. Shah" <pshah.mumbai@gmail.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: linux-next: manual merge of the staging-next tree with the
 pcmcia tree
Message-ID: <20100802222335.GA26966@kroah.com>
References: <20100802135746.b869dabc.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100802135746.b869dabc.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 02, 2010 at 01:57:46PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging-next tree got a conflict in
> drivers/staging/wlags49_h2/wl_cs.c between commits
> 9b3efec734d2d79d82a6f5cef25a618d41a6b2c5 ("pcmcia: do not use io_req_t
> after call to pcmcia_request_io()") and
> cd8ae1e0a5d36406b518cea25446492f07ddddcf ("pcmcia: do not use io_req_t
> when calling pcmcia_request_io()") from the pcmcia tree and commit
> 6d98be390ab55bb5f617d69aedf9bec27d039b3b ("Staging: wl_cs.c: converted
> space to tabs in wl_cs.c") from the staging-next tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.

Those fixes are fine, thanks for doing this.

greg k-h

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229Ab0JSP5Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 11:57:25 -0400
Received: from kroah.org ([198.145.64.141]:59750 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754087Ab0JSPzr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 11:55:47 -0400
Date: Tue, 19 Oct 2010 08:47:08 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Daney <ddaney@caviumnetworks.com>,
        Ralf Baechle <ralf@linux-mips.org>, Anatolij Gustschin <agust@denx.de>
Subject: Re: linux-next: manual merge of the usb tree with the mips tree
Message-ID: <20101019154707.GE4589@kroah.com>
References: <20101018170911.63f76c60.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101018170911.63f76c60.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 18, 2010 at 05:09:11PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the usb tree got a conflict in
> drivers/usb/host/Makefile between commit
> cd97084c3aff6f1037e00ee711a872719b60441d ("USB: Add EHCI and OHCH glue
> for OCTEON II SOCs") from the mips tree and commit
> f668f1e9868f9bc1bed3d5df1701879ac89cc3ed ("USB: add platform glue driver
> for FSL USB DR controller") from the usb tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.

Thanks for the fix, looks fine.

greg k-h

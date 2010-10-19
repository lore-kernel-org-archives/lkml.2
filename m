Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754937Ab0JSP5m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 11:57:42 -0400
Received: from kroah.org ([198.145.64.141]:59745 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754032Ab0JSPzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 11:55:46 -0400
Date: Tue, 19 Oct 2010 08:46:54 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Anatolij Gustschin <agust@denx.de>,
        David Daney <ddaney@caviumnetworks.com>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: Re: linux-next: manual merge of the usb tree with the mips tree
Message-ID: <20101019154654.GD4589@kroah.com>
References: <20101018170619.25f6566f.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101018170619.25f6566f.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 18, 2010 at 05:06:19PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the usb tree got a conflict in
> drivers/usb/host/Kconfig between commit
> cd97084c3aff6f1037e00ee711a872719b60441d ("USB: Add EHCI and OHCH glue
> for OCTEON II SOCs") from the mips tree and commit
> c67a807cb13570bfc7b78f53158d14a433c59591 ("USB: add USB EHCI support for
> MPC5121 SoC") from the usb tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.

Thanks for the fix, looks fine.

greg k-h

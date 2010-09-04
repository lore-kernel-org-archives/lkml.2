Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551Ab0IDCPq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 22:15:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33837 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753733Ab0IDCPo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 22:15:44 -0400
Date: Fri, 3 Sep 2010 19:16:27 -0700
From: Greg KH <gregkh@suse.de>
To: Vipin Mehta <Vipin.Mehta@Atheros.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for September 3 (ar6k)
Message-ID: <20100904021627.GA7695@suse.de>
References: <20100903135206.d9bc2093.sfr@canb.auug.org.au> <20100903180614.81e5eee0.randy.dunlap@oracle.com> <35B17FE5076C7040809188FBE7913F983F23479B57@SC1EXMB-MBCL.global.atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35B17FE5076C7040809188FBE7913F983F23479B57@SC1EXMB-MBCL.global.atheros.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 03, 2010 at 07:02:36PM -0700, Vipin Mehta wrote:
> Apologies for the inconvenience. I synced to the linux-next tree and looked into the drivers/staging/ath6kl directory. I was able to compile the driver without any issues.
> 
> One of the reasons this might happen is if the following symbolic link is broken.
> 
> drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw
> 
> The link should point to drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw.0

I applied the patch and the symlink "should" be there, but in general,
we shouldn't rely on a symlink in the kernel tree to work properly.

Can you send me a patch to fix this up so it works without a symlink?

thanks,

greg k-h

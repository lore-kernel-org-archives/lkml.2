Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131Ab1DNEvY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 00:51:24 -0400
Received: from kroah.org ([198.145.64.141]:40981 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752802Ab1DNEvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 00:51:22 -0400
Date: Wed, 13 Apr 2011 21:52:24 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: linux-next: manual merge of the usb tree with the s5p tree
Message-ID: <20110414045224.GB19370@kroah.com>
References: <20110414141526.e0d5efa1.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110414141526.e0d5efa1.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14, 2011 at 02:15:26PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the usb tree got a conflict in
> arch/arm/mach-exynos4/mach-nuri.c between commit d2a852f78de6 ("ARM:
> EXYNOS4: Add Atmel mXT touchscreen device to the NURI board") from the
> s5p tree and commit 01da92f7f643 ("ARM: EXYNOS4: Add usb ehci device to
> the NURI board") from the usb tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.

Thanks, the fix looks fine, I knew something like this would happen, and
it would be easy to handle the merge.

thanks,

greg k-h

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287Ab2ERPVM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 11:21:12 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:56530 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752133Ab2ERPVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 11:21:10 -0400
X-Sasl-enc: zpbqGL+snKlQGxDRFm/S9+5aahISvvJA44TLCopZQd4L 1337354468
Date: Fri, 18 May 2012 08:21:07 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lukasz Majewski <l.majewski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: linux-next: manual merge of the usb tree with the s5p tree
Message-ID: <20120518152107.GA10274@kroah.com>
References: <20120518172224.abd97797bab5d99eaeec97a5@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120518172224.abd97797bab5d99eaeec97a5@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 05:22:24PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the usb tree got a conflict in
> arch/arm/mach-exynos/mach-universal_c210.c between commit 6dafa4aead1b
> ("ARM: EXYNOS: Add DRM core device support for Universal C210 board")
> from the s5p tree and commit 3a36dd068f43 ("ARM: EXYNOS: Add s3c-hsotg
> device support for Universal C210 board") from the usb tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.

Looks good to me, thanks.

greg k-h

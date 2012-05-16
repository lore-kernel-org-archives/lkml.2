Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759921Ab2EPMGv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 08:06:51 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:54986 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756377Ab2EPMGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 08:06:49 -0400
X-Sasl-enc: zEfG9nfmDuCMZLQ01LWPi84sHHfiIeB0M+P6IfHHyDEL 1337170008
Date: Wed, 16 May 2012 05:06:44 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>
Subject: Re: linux-next: manual merge of the usb tree with the s5p tree
Message-ID: <20120516120644.GA31261@kroah.com>
References: <20120516180303.3c3cff646c1a70a8ddf32e2a@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120516180303.3c3cff646c1a70a8ddf32e2a@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 06:03:03PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the usb tree got a conflict in
> arch/arm/mach-exynos/mach-universal_c210.c between commit 6dafa4aead1b
> ("ARM: EXYNOS: Add DRM core device support for Universal C210 board")
> from the s5p tree and commit 126625e1bf32 ("usb:hsotg:samsung:cosmetic
> Move <linux/platform_data/s3c-hsotg.h> to proper place") from the usb
> tree.
> 
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.

Looks good to me, thanks.

greg k-h

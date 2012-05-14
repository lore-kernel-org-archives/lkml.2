Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895Ab2ENO2P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 10:28:15 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:50816 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756444Ab2ENO2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 10:28:13 -0400
X-Sasl-enc: fbhr+hVpSUZpflznB+QLLiwutkEkAWIWVekebNg9nQgl 1337005693
Date: Mon, 14 May 2012 07:28:11 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lukasz Majewski <l.majewski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: linux-next: manual merge of the usb tree with the s5p tree
Message-ID: <20120514142811.GB14091@kroah.com>
References: <20120514174743.de608c90ed9653d827707a7b@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120514174743.de608c90ed9653d827707a7b@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2012 at 05:47:43PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the usb tree got conflicts in
> arch/arm/mach-exynos/mach-nuri.c  and
> arch/arm/mach-exynos/mach-universal_c210.c between commits db6856e8d8ab
> ("ARM: EXYNOS: Add DRM core support for NURI board") and 6dafa4aead1b
> ("ARM: EXYNOS: Add DRM core device support for Universal C210 board")
> from the s5p tree and commit 126625e1bf32 ("usb:hsotg:samsung:cosmetic
> Move <linux/platform_data/s3c-hsotg.h> to proper place") from the usb
> tree.
> 
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.

Looks good to me, thanks.

greg k-h

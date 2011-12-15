Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036Ab1LOIJi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 03:09:38 -0500
Received: from h1778886.stratoserver.net ([85.214.133.74]:57157 "EHLO
	h1778886.stratoserver.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037Ab1LOIJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 03:09:37 -0500
From: Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>
To: axel.lin@gmail.com
Subject: Re: [linux-next] make s5p64x0_defconfig build error
Date: Thu, 15 Dec 2011 09:09:25 +0100
User-Agent: KMail/1.13.7 (Linux/2.6.39-2-amd64; KDE/4.6.4; x86_64; ; )
Cc: Kukjin Kim <kgene.kim@samsung.com>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <1323838630.18517.1.camel@phoenix> <028901ccbab8$c2c43890$484ca9b0$%kim@samsung.com> <CAF+7xWn80ZsgBNS80f0JYUXx2KN3VGM-Y2EOba7OLMwMGNfbKg@mail.gmail.com>
In-Reply-To: <CAF+7xWn80ZsgBNS80f0JYUXx2KN3VGM-Y2EOba7OLMwMGNfbKg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201112150909.26229.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 15. Dezember 2011, 00:54:58 schrieb Axel Lin:
> Hi Kukjin,
> 
> > Axel and Will, thanks for pointing out.
> > 
> > Oops, I couldn't have much time to follow up :(
> > But let me look at that in this weekend and I know, it can be escaped
> > before merge window :)
> 
> I also found the same build errors by:
> make s5pc100_defconfig
> make s5pv210_defconfig
> make exynos4_defconfig

make s3c2410_defconfig
also produces the build errors

Heiko

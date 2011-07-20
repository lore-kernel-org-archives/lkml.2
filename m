Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003Ab1GTTtV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 15:49:21 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44788 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751584Ab1GTTtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 15:49:20 -0400
Date: Wed, 20 Jul 2011 20:49:16 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Stephen Warren <swarren@nvidia.com>, Erik Gilling <konkers@android.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] arm/dt: tegra devicetree support
Message-ID: <20110720194915.GA26043@opensource.wolfsonmicro.com>
References: <20110719234158.2779.15394.stgit@ponder>
 <74CDBE0F657A3D45AFBB94109FB122FF049EBDEE27@HQMAIL01.nvidia.com>
 <20110720160355.GB2406@sirena.org.uk>
 <20110720183133.GE4642@ponder.secretlab.ca>
 <74CDBE0F657A3D45AFBB94109FB122FF049EBDEF01@HQMAIL01.nvidia.com>
 <20110720184758.GG4642@ponder.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110720184758.GG4642@ponder.secretlab.ca>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 20, 2011 at 12:47:58PM -0600, Grant Likely wrote:

> Sure, the tegra-wm8903 property can be dropped.  If we start to see a
> really well established pattern of the tegra paired with a wm8903,
> then at that point we can define a compatible property for it and
> document exactly what it means (document the boundaries and
> assumptions that the compatible value requires).

There is actually such a pattern, for various reasons a huge proportion
of Tegra systems are straight clones of the reference designs and the
reference designs mostly used WM8903.

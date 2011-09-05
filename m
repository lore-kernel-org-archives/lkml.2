Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752426Ab1IEWAH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 18:00:07 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42510 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751420Ab1IEWAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 18:00:03 -0400
Date: Mon, 5 Sep 2011 14:59:53 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        device-drivers-devel@blackfin.uclinux.org,
        uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
        Scott Jiang <scott.jiang.linux@gmail.com>
Subject: Re: [PATCH v2 1/2] regmap: Add support for device specific write and
 read flag masks.
Message-ID: <20110905215952.GC11107@opensource.wolfsonmicro.com>
References: <1315248393-31791-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315248393-31791-1-git-send-email-lars@metafoo.de>
X-Cookie: You will wish you hadn't.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 05, 2011 at 08:46:32PM +0200, Lars-Peter Clausen wrote:
> Some buses like SPI have no standard notation of read or write operations.
> The general scheme here is to set or clear specific bits in the register
> address to indicate whether the operation is a read or write. We already
> support having a read flag mask per bus, but as there is no standard
> the bits which need to be set or cleared differ between devices and vendors,
> thus we need a mechanism to specify them per device.

So, I tried to apply this to my topic/interface branch (which is where
I'm keeping stuff for merge into other trees) but that won't fly due to
the internal.h change.  What I might do to resolve the merge issues is
to make a commit with the new regmap.h changes alone.  This won't help
in terms of actually running things but it'll keep things buildable
which is more achievable.

Anyway, thanks for doing this - there's a bunch of other devices that
need this.

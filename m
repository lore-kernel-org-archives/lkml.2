Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758379Ab0GTJD6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 05:03:58 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33635 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758316Ab0GTJD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 05:03:57 -0400
Date: Tue, 20 Jul 2010 10:03:55 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Takashi Iwai <tiwai@suse.de>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Ryan Mallon <ryan@bluewatersys.com>
Subject: Re: linux-next: manual merge of the sound tree with the arm tree
Message-ID: <20100720090355.GL10222@rakim.wolfsonmicro.main>
References: <20100719110054.de489964.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100719110054.de489964.sfr@canb.auug.org.au>
X-Cookie: Who was that masked man?
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 19, 2010 at 11:00:54AM +1000, Stephen Rothwell wrote:

> Today's linux-next merge of the sound tree got a conflict in
> arch/arm/mach-ep93xx/clock.c between commit
> 5c6649e3c1511b183f12d2e884d2c172fe9001e0 ("ARM: AMBA: Add pclk definition
> for platforms using primecells") from the arm tree and commit
> ed67ea82c0d9a163458dc6a69a7a3123db1a8b3b ("EP93xx: Add i2s core support")
> from the sound tree.

> Just overlapping additions.  I fixed it up (see below) and can carry the
> fix as necessary.

Ryan, can you investigate where (if anywhere is good) the best place to
carry the merge fixup is please?

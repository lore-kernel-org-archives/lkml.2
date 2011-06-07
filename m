Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849Ab1FGOUj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 10:20:39 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:57948 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755069Ab1FGOUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 10:20:36 -0400
Date: Tue, 7 Jun 2011 08:20:32 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        Mika Westerberg <mika.westerberg@iki.fi>,
        Vinod Koul <vinod.koul@intel.com>
Subject: Re: linux-next: manual merge of the gpio tree with the slave-dma tree
Message-ID: <20110607142032.GB13072@ponder.secretlab.ca>
References: <20110607125723.8e591e42.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110607125723.8e591e42.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 07, 2011 at 12:57:23PM +1000, Stephen Rothwell wrote:
> Hi Grant,
> 
> Today's linux-next merge of the gpio tree got a conflict in
> arch/arm/mach-ep93xx/Makefile between commit 8e4a93008db7 ("ep93xx:
> remove the old M2P DMA code") from the slave-dma tree and commit
> c6b52c13de44 ("gpio/ep93xx: move driver to drivers/gpio") from the gpio
> tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.

Okay, thanks Stephen.  Obviously that is the correct fixup.

g.

> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc arch/arm/mach-ep93xx/Makefile
> index 21e721a,6b7c41d..0000000
> --- a/arch/arm/mach-ep93xx/Makefile
> +++ b/arch/arm/mach-ep93xx/Makefile
> @@@ -1,7 -1,7 +1,7 @@@
>   #
>   # Makefile for the linux kernel.
>   #
> - obj-y			:= core.o clock.o gpio.o
>  -obj-y			:= core.o clock.o dma-m2p.o
> ++obj-y			:= core.o clock.o
>   obj-m			:=
>   obj-n			:=
>   obj-			:=

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040Ab0GMBz7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 21:55:59 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:36254 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399Ab0GMBz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 21:55:58 -0400
Date: Tue, 13 Jul 2010 10:55:42 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Uwe Kleine-K??nig <u.kleine-koenig@pengutronix.de>
Subject: Re: linux-next: manual merge of the genesis tree with Linus' tree
Message-ID: <20100713015542.GB12728@linux-sh.org>
References: <20100713112814.39dbd280.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100713112814.39dbd280.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 13, 2010 at 11:28:14AM +1000, Stephen Rothwell wrote:
> Hi Paul,
> 
> Today's linux-next merge of the genesis tree got a conflict in
> arch/arm/configs/ap4evb_defconfig arch/arm/configs/g3evm_defconfig
> arch/arm/configs/g4evm_defconfig between commit
> 07a8c03f3e06129e847acd068b8b89c13357ee64 ("ARM: reduce defconfigs") from
> Linus' tree and commits 4a539a2023fd2f7384916ef6e7777ad234a00dcd ("ARM:
> mach-shmobile: update defconfigs") and
> 1ddb76fd29da170d77d70b94cdcba74b0d935152 ("ARM: mach-shmobile: update
> ap4evb defconfig for MMC/DMA changes") from the genesis tree.
> 
> The changes are far to extensive for me to fix up, so I have used the
> versions from the genesis tree for today.
> 
> Paul you should merge in Linus' tree (or rebase) and use Uwe's script on
> your updated config files ...
> 
I'll take care of it today, sorry for the trouble!

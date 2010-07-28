Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040Ab0G1D7T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 23:59:19 -0400
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:54589 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753330Ab0G1D7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 23:59:17 -0400
Date: Wed, 28 Jul 2010 09:28:49 +0530
From: Rabin VINCENT <rabin.vincent@stericsson.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Dan Williams <dan.j.williams@intel.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <rmk@arm.linux.org.uk>,
        Jonas ABERG <jonas.aberg@stericsson.com>,
        Linus WALLEIJ <linus.walleij@stericsson.com>
Subject: Re: linux-next: manual merge of the async_tx tree with the arm tree
Message-ID: <20100728035849.GA14721@bnru02.bnr.st.com>
References: <20100727120805.f583c70b.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100727120805.f583c70b.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Tue, Jul 27, 2010 at 04:08:05 +0200, Stephen Rothwell wrote:
> Today's linux-next merge of the async_tx tree got a conflict in
> arch/arm/mach-ux500/devices-db8500.c between commit
> 6055930cba8fdb2c8855b32bae262aaf69c1fdb4 ("ARM: 6266/1: ux500: add
> separate irq lists for DB8500 and DB5500") from the arm tree and commit
> 5aa12e8c9c57741606e52f43e62ab1b9dc8e9dcc ("DMAENGINE: ste_dma40: arch
> updates for LCLA and LCPA") from the async_tx tree.
> 
> I fixed it up (I think - see below) and can carry the fix as necessary.

The fixup is correct, thanks.

Rabin

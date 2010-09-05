Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835Ab0IEXdY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 19:33:24 -0400
Received: from sh.osrg.net ([192.16.179.4]:38957 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754488Ab0IEXdX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 19:33:23 -0400
Date: Mon, 6 Sep 2010 08:32:45 +0900
To: linux@arm.linux.org.uk
Cc: fujita.tomonori@lab.ntt.co.jp, khc@pm.waw.pl,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm: fix pci_set_consistent_dma_mask for dmabounce
	devices
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100905112513.GB558@n2100.arm.linux.org.uk>
References: <20100901085738.GJ8142@n2100.arm.linux.org.uk>
	<20100902114937X.fujita.tomonori@lab.ntt.co.jp>
	<20100905112513.GB558@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100906083105X.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 06 Sep 2010 08:32:47 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Sep 2010 12:25:13 +0100
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> > This restores the trick that had worked.
> > 
> > btw, I can't compile ARCH_IXP4XX without the following patch:
> > 
> > http://www.spinics.net/lists/arm-kernel/msg95933.html
> > 
> > =
> > From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > Subject: [PATCH] arm: fix arm: fix pci_set_consistent_dma_mask for dmabounce devices
> > 
> > This fixes the regression caused by the commit
> > 6fee48cd330c68332f9712bc968d934a1a84a32a.
> > 
> > ARM needs to clip the dma coherent mask for dmabounce devices. This
> > restores the old trick.
> > 
> > Note that strictly speaking, the DMA API doesn't allow architectures
> > to do such but I'm not sure it's worth adding the new API to set the
> > dma mask that allows architectures to clip it.
> > 
> > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> 
> Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>

Should I send this to Linus? Or Can I assume that someone in ARM camp
will do?

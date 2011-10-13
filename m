Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248Ab1JMVMQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 17:12:16 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52020 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902Ab1JMVMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 17:12:15 -0400
Date: Thu, 13 Oct 2011 22:11:45 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Andrew Victor <avictor.za@gmail.com>
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Maxim Osipov <maxim.osipov@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Andrew Victor <linux@maxim.org.za>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] AT91: Add external RTC for Flexibity board
Message-ID: <20111013211145.GA27779@n2100.arm.linux.org.uk>
References: <4DC53134.8070706@gmail.com> <20110510234526.GC18929@game.jcrosoft.org> <BANLkTikvCiXgnm_hVTqDmzZ6yDf6H5WaCw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikvCiXgnm_hVTqDmzZ6yDf6H5WaCw@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 09:44:52AM +0200, Andrew Victor wrote:
> hi,
> 
> >> This patch enables external RTC support on AT91 Flexibity board.
> 
> Acked-by: Andrew Victor <linux@maxim.org.za>
> 
> Maxim: You can submit it to Russell's patch system.
> 
> 
> > looks fine just one comment please add your board to the new at91sam9260_defconfig
> 
> That file does not exist in any mainline kernel.

It's been a while since this patch went into the patch system, and it
didn't get applied for various reasons, including because it looked
like it was sent there without any review (no acked-by's etc added to
it.)

What's the status of this - and if its still relevant can we have
it with the proper attributations please?

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932270Ab2HPNNx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 09:13:53 -0400
Received: from antcom.de ([188.40.178.216]:39721 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932161Ab2HPNNv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 09:13:51 -0400
Message-ID: <502CF20C.20801@antcom.de>
Date: Thu, 16 Aug 2012 15:13:48 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: artem.bityutskiy@linux.intel.com, linux-arm-kernel@lists.infradead.org,
        arnd@arndb.de, linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, aletes.xgr@gmail.com, dwmw2@infradead.org,
        linux-mtd@lists.infradead.org
Subject: Re: [PATCH] dma: amba-pl08x: Export pl08x_filter_id
References: <1345107396-27079-1-git-send-email-stigge@antcom.de> <20120816090041.GK18957@n2100.arm.linux.org.uk>
In-Reply-To: <20120816090041.GK18957@n2100.arm.linux.org.uk>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2012 11:00 AM, Russell King - ARM Linux wrote:
> On Thu, Aug 16, 2012 at 10:56:36AM +0200, Roland Stigge wrote:
>> This patch fixes the following when compiling a driver module that uses
>> amba-pl08x:
>>
>> ERROR: "pl08x_filter_id" [drivers/mtd/nand/lpc32xx_slc.ko] undefined!
>> ERROR: "pl08x_filter_id" [drivers/mtd/nand/lpc32xx_mlc.ko] undefined!
>>
>> (drivers/mtd/nand/lpc32xx_* are still in l2-mtd.git)
> 
> It is currently intended that this be passed from platform code into
> drivers via platform data, so that drivers can decide which DMA engine
> they wish to make use of.
> 
> See how all the AMBA drivers work in this regard (because they need to
> support more than just a single DMA engine implementation.)

Thanks for the note!

I'll post respective changes to the MTD SLC and MLC drivers of LPC32xx
(for the MTD subsystem) and the adjustment I'll do in mach-lpc32xx (my
lpc32xx tree for arm-soc).

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030980Ab2HQKwv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 06:52:51 -0400
Received: from antcom.de ([188.40.178.216]:46571 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030978Ab2HQKwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 06:52:47 -0400
Message-ID: <502E2279.1030604@antcom.de>
Date: Fri, 17 Aug 2012 12:52:41 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: artem.bityutskiy@linux.intel.com
CC: linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        arnd@arndb.de, linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, aletes.xgr@gmail.com, dwmw2@infradead.org,
        linux-mtd@lists.infradead.org
Subject: Re: [PATCH] ARM: LPC32xx: Provide DMA filter callbacks via platform
 data
References: <1345122935-22115-1-git-send-email-stigge@antcom.de> <1345198171.27859.39.camel@sauron.fi.intel.com>
In-Reply-To: <1345198171.27859.39.camel@sauron.fi.intel.com>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17/2012 12:09 PM, Artem Bityutskiy wrote:
> On Thu, 2012-08-16 at 15:15 +0200, Roland Stigge wrote:
>> The SLC and MLC NAND drivers now need their dma_filter callbacks
>> via platform data to make them independent of single DMA engine
>> drivers.
>> 
>> (This also helps fixing build errors of the SLC and MLC drivers
>> when building as modules because direct access to AMBA dma filter
>> functions isn't available via export.)
>> 
>> Signed-off-by: Roland Stigge <stigge@antcom.de>
> 
> Pushed the 3 patches to l2-mtd.git, thanks!

To later avoid collisions on subsystem merge, can you please leave the
patch with arch/arm/mach-lpc32xx/phy3250.c for arm-soc.git? (I will
provide a pull request for Arnd and Olof, as usual.)

Thanks,

Roland

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756404Ab2HPO06 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 10:26:58 -0400
Received: from antcom.de ([188.40.178.216]:51212 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753060Ab2HPO04 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 10:26:56 -0400
Message-ID: <502D032D.1000301@antcom.de>
Date: Thu, 16 Aug 2012 16:26:53 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: artem.bityutskiy@linux.intel.com
CC: linux-arm-kernel@lists.infradead.org, arnd@arndb.de,
        linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com, aletes.xgr@gmail.com,
        dwmw2@infradead.org, linux-mtd@lists.infradead.org
Subject: Re: [PATCH 1/2] mtd: lpc32xx_slc: Adjust to pl08x DMA interface changes
References: <1342095778-13403-1-git-send-email-stigge@antcom.de>  <1342095778-13403-2-git-send-email-stigge@antcom.de> <1345027069.3393.124.camel@sauron.fi.intel.com>
In-Reply-To: <1345027069.3393.124.camel@sauron.fi.intel.com>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 08/15/2012 12:37 PM, Artem Bityutskiy wrote:
> On Thu, 2012-07-12 at 14:22 +0200, Roland Stigge wrote:
>> This patch adjusts the LPC32xx SLC NAND driver to the new pl08x
>> DMA interface, fixing the compile error resulting from changed
>> pl08x structures.
>> 
>> Signed-off-by: Roland Stigge <stigge@antcom.de>
> 
> This patch breaks compilation:
> 
> ERROR: "pl08x_filter_id" [drivers/mtd/nand/lpc32xx_slc.ko]
> undefined!
> 
> Please, send a fix. The defconfig I used is attached.

Please see my just posted patches:

mtd: lpc32xx_slc: Make driver independent of AMBA DMA engine driver
mtd: lpc32xx_mlc: Make driver independent of AMBA DMA engine driver

This also fixes the above problem by getting rid of the reference to
pl08x_filter_id.

Thanks,

Roland

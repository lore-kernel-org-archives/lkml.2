Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441Ab2HZO1O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 10:27:14 -0400
Received: from antcom.de ([188.40.178.216]:58747 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753084Ab2HZO1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 10:27:11 -0400
Message-ID: <503A323A.9090309@antcom.de>
Date: Sun, 26 Aug 2012 16:27:06 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM Open Source Research and Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: linux@arm.linux.org.uk, artem.bityutskiy@linux.intel.com,
        linux-arm-kernel@lists.infradead.org, arnd@arndb.de,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, aletes.xgr@gmail.com, dwmw2@infradead.org,
        linux-mtd@lists.infradead.org
Subject: Re: [PATCH RESEND] mtd: lpc32xx_mlc: Make driver independent of AMBA
 DMA engine driver
References: <1345674311-16874-1-git-send-email-stigge@antcom.de> <1345898007.1815.7.camel@kyv>
In-Reply-To: <1345898007.1815.7.camel@kyv>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 25/08/12 14:33, Artem Bityutskiy wrote:
> On Thu, 2012-08-23 at 00:25 +0200, Roland Stigge wrote:
>> This patch makes the MLC NAND driver independent of the single
>> AMBA DMA engine driver by using the platform data provided
>> dma_filter callback.
>> 
>> (This also fixes the build error of the MLC NAND driver in case
>> of module linking because the (not exported) reference to
>> pl08x_filter_id is gone now.)
>> 
>> Signed-off-by: Roland Stigge <stigge@antcom.de>
> 
> I already have both patches in l2-mtd.git. Please, use it as the 
> baseline for sending patches.

Yes, noticed to late that you have already applied it, sorry.

The recently posted cleanup patches for LPC32xx SLC and MLC drivers
apply to l2-mtd.git, anyway.

Thanks,

Roland

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703Ab2HPJAA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 05:00:00 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:60461 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756512Ab2HPI76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 04:59:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Roland Stigge <stigge@antcom.de>
Subject: Re: [PATCH] dma: amba-pl08x: Export pl08x_filter_id
Date: Thu, 16 Aug 2012 08:59:49 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: artem.bityutskiy@linux.intel.com, linux-arm-kernel@lists.infradead.org,
        linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com, aletes.xgr@gmail.com,
        dwmw2@infradead.org, linux-mtd@lists.infradead.org
References: <1345107396-27079-1-git-send-email-stigge@antcom.de>
In-Reply-To: <1345107396-27079-1-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201208160859.49317.arnd@arndb.de>
X-Provags-ID: V02:K0:0NqreTJ8d2+faopyMwiML8aTErB/LdUyqi7lfn88bFh
 Qev3x5lF/++jn48EgaSrS1+XRPvI2pNIQ/S/A84/QX29yiz+xZ
 u5pn75ZARoI6PCGS1XGUnI+rLox8QlXVeaJxIEKytUq3IfiU9a
 EL+EFOL+ohGvf5qeI6Z7SVXy/qfwPp1PYUhLI5r2wZt0qAnU0V
 SMdvv7Pzr8tOy9Ua2K0FY/dpvd74bG9059d5Nv9/qbqzwM2Hx/
 +OmhHe62ZgwOdOO2FOJ22pEm/p1er3+/IwoKNtCLMgJ0XpWqGf
 mxKSmOQ/2jxSj6J2zt1Vuywh6wt9Hij44CXps4Z/qX+1T5HnqF
 8iIDbBBA0x/sUWr3U920=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 August 2012, Roland Stigge wrote:
> This patch fixes the following when compiling a driver module that uses
> amba-pl08x:
> 
> ERROR: "pl08x_filter_id" [drivers/mtd/nand/lpc32xx_slc.ko] undefined!
> ERROR: "pl08x_filter_id" [drivers/mtd/nand/lpc32xx_mlc.ko] undefined!
> 
> (drivers/mtd/nand/lpc32xx_* are still in l2-mtd.git)
> 
> Done as in:
> 
> drivers/dma/coh901318.c
> drivers/dma/sirf-dma.c
> 
> Signed-off-by: Roland Stigge <stigge@antcom.de>

Acked-by: Arnd Bergmann <arnd@arndb.de>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188Ab2HOMJQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 08:09:16 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:47913 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353Ab2HOMJP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 08:09:15 -0400
X-Auth-Info: FFYvJricsxghuoMW1vmNNWlB+Z7Qs43/fPyn6xENt5E=
From: Marek Vasut <marex@denx.de>
To: linux-mtd@lists.infradead.org
Subject: Re: [PATCH] mtd: kill MTD_NAND_VERIFY_WRITE
Date: Wed, 15 Aug 2012 14:09:12 +0200
User-Agent: KMail/1.13.7 (Linux/3.4-trunk-amd64; KDE/4.8.4; x86_64; ; )
Cc: Huang Shijie <b32955@freescale.com>,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>, dedekind1@gmail.com,
        Huang Shijie <shijie8@gmail.com>, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org
References: <1344998325-3279-1-git-send-email-shijie8@gmail.com> <20120815100655.479e2c39@pixies.home.jungo.com> <502B63AD.4000604@freescale.com>
In-Reply-To: <502B63AD.4000604@freescale.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201208151409.12390.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Huang Shijie,

> 于 2012年08月15日 15:06, Shmulik Ladkani 写道:
> > Hi Huang,
> > 
> > On Tue, 14 Aug 2012 22:38:45 -0400 Huang Shijie<shijie8@gmail.com>  wrote:
> >> diff --git a/drivers/mtd/nand/Kconfig b/drivers/mtd/nand/Kconfig
> >> index 588e989..0ca7257 100644
> >> --- a/drivers/mtd/nand/Kconfig
> >> +++ b/drivers/mtd/nand/Kconfig
> >> @@ -22,15 +22,6 @@ menuconfig MTD_NAND
> >> 
> >>   if MTD_NAND
> >> 
> >> -config MTD_NAND_VERIFY_WRITE
> >> -	bool "Verify NAND page writes"
> >> -	help
> >> -	  This adds an extra check when data is written to the flash. The
> >> -	  NAND flash device internally checks only bits transitioning
> >> -	  from 1 to 0. There is a rare possibility that even though the
> >> -	  device thinks the write was successful, a bit could have been
> >> -	  flipped accidentally due to device wear or something else.
> >> -
> > 
> > There are some defconfig files which set CONFIG_MTD_NAND_VERIFY_WRITE.
> > 
> > I guess you should submit an accompanying patch that removes
> > CONFIG_MTD_NAND_VERIFY_WRITE from all defconfig files.
> 
> thanks a lot.
> 
> I will send out a separate patch to fix it.

I'd still prefer for this to be rather fixed. It seems to be able to find some 
obvious mistakes etc.

[...]

Best regards,
Marek Vasut

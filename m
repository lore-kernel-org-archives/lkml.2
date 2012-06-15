Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246Ab2FOMHX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 08:07:23 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:55884 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754076Ab2FOMHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 08:07:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Roland Stigge <stigge@antcom.de>
Subject: Re: [PATCH v2 00/23] ARM: LPC32xx specific updates for next
Date: Fri, 15 Jun 2012 12:07:06 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, aletes.xgr@gmail.com
References: <1339692673-7848-1-git-send-email-stigge@antcom.de>
In-Reply-To: <1339692673-7848-1-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201206151207.07108.arnd@arndb.de>
X-Provags-ID: V02:K0:o856hGWMxig8kpM+o2r8eyScL8Z1CkYlL+Dkb1FDTwK
 boaQ9bFSe76gSY9lZEPufUjwvUIowAcC72GAAAnXyEPLrPElNY
 N6NgSpDEt6Vub0+fF80dGMHXb71usH4LCVnQSlRP+WvuIGCLpe
 Eno8MVIALUIrurxuqIHvAiftNMhGHg+ojlrLgv6tw1FXFDyEcK
 35KX4fNb3ifrpDSh8VxrO1I3CAiD2PdUtoR7jCSZL2kNV/o33f
 bd5eLuDe2Pm0+wB/PNC/+nS1Qxr61IXzsays17811rb7tBvwQB
 SCG6vumeuQBeuKJ6uaSthw78iBqEwCl5Z+LXl5MWEKRhcsE5iV
 AnOcfCh+A+LB0ogAkDOc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 June 2012, Roland Stigge wrote:
> This patch set includes various updates for mach-lpc32xx, including DT binding
> for serial, and dts updates. A new reference board is supported (EA3250). The
> board support file phy3250.c is updated to become more general, useable for
> other boards also. There is still board specific stuff in it, though (some
> devicetree auxdata).
> 
> Further, clock updates, DMA support, MMC support and a defconfig update for
> LPC32xx is included.
> 
> Signed-off-by: Roland Stigge <stigge@antcom.de>
> 
> --
> Applies to v3.5-rc2
> 
> Changes since v1:
> * Don't use pointers to functions in dma init struct (Patch 4)
> * Adjusted DT property status: "disable" -> "disabled" (Patch 15)
> * defconfig: Added MTD_M25P80 (Patch 9)
> * Fixed USB PHY I2C address for EA3250 (Patch 6)
> * Added patches 16 through 23 by Alexandre Pereira da Silva
> 
> You can also pull from
> 
>   git://git.antcom.de/linux-2.6.git lpc32xx-next

It all looks good from my point of view, so I think we can pull it
for 3.6 if no other comments come.

	Arnd

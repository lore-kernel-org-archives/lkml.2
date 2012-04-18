Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424Ab2DRIhW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 04:37:22 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:57721 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261Ab2DRIhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 04:37:16 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Thierry Reding <thierry.reding@avionic-design.de>
Subject: Re: [PATCH v2 8/8] ARM: LPC32xx: Device tree support
Date: Wed, 18 Apr 2012 08:15:28 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Roland Stigge <stigge@antcom.de>, arm@kernel.org,
        linux-arm-kernel@lists.infradead.org, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
        axel.lin@gmail.com, broonie@opensource.wolfsonmicro.com,
        marek.vasut@gmail.com, devel@driverdev.osuosl.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com
References: <1334682507-15055-1-git-send-email-stigge@antcom.de> <1334682507-15055-9-git-send-email-stigge@antcom.de> <20120418060230.GC17506@avionic-0098.adnet.avionic-design.de>
In-Reply-To: <20120418060230.GC17506@avionic-0098.adnet.avionic-design.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201204180815.29234.arnd@arndb.de>
X-Provags-ID: V02:K0:/3lhTz0BdxAQamBBoQhLYAMIPI6wIqmeGXrZDHEyihf
 uMzvIyauBrxAYaiHuxYinNXPBf/1930kEJda4uv++4id1+NYfQ
 xZw/Q/StEgP4AmUoQmHudyBgjhUyI0IumX8mOV6GhDX3aXK+ZN
 F9/ZNzfoUDZu0DhQdy7Lhuzps8ut5EmFAYomBa8SHCObiABVJL
 VR5Ep/12pOtO+gP5phyol5WsM/hbMwx0EQFXVyne+bSvzPPChV
 ZsYVZXIr8jH+s0eRbxFTy6ou+5mxdShP6y87q6XHR4pwg9RErq
 yK40/zhWYiwZLBhPGeMpLslCY3CGo9wr68kh3N+vx/Qv5Zfx9y
 zeV/fGHZyaxkhHGvZXGw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 April 2012, Thierry Reding wrote:
> >  arch/arm/mach-lpc32xx/phy3250.c                       |  146 +++++--------
> 
> While at it, this should probably be renamed board-dt.c or something similar
> since it is no longer phy3250 specific.

I believe there are still a few phy3250 specific bits left in there, using auxdata,
right? In that case, I think it's fine to leave the file name for now, but I
think everyhting that is not phy3250 specific should just get moved into common.c
since we don't want to support any other board files for lpc32xx any more.

	Arnd


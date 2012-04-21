Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123Ab2DULVz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 07:21:55 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:62212 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087Ab2DULVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 07:21:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 02/17] ARM clps711x: Added Cirrus Logic EP7312 CPU variant
Date: Sat, 21 Apr 2012 11:21:49 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Alexander Shiyan <shc_work@mail.ru>, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
References: <1334999490-27177-1-git-send-email-shc_work@mail.ru> <1334999490-27177-3-git-send-email-shc_work@mail.ru>
In-Reply-To: <1334999490-27177-3-git-send-email-shc_work@mail.ru>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201204211121.49610.arnd@arndb.de>
X-Provags-ID: V02:K0:FpIhci1gWSuJM1A4o2ycKPs4X074IFwF3g7iLmW1GXE
 PU6UQE3V7eruOBwXbM1nB0tIelSRfRsIsnkvSLbDdEOB3OeUDR
 VwP76Xmk/0Fby6UnlQwOKq73LVdVUQT6TNYi0ngKXPzlM3CQR9
 gu3NiJBlXPN71pKOXJWK6+zz8OqJiMHFKOgDkcEf75Hfg+VXrw
 B+t4fJNeEVckK9XGE37WgDblvJrDIBYF+hE9XuQCEB49Ru/c0c
 Ffb47top/oGvQYtcLc06wUtJqcJUaP9DkVeGR3Qyov2lcNCX0I
 A/TNxCbCRdwEu4JzHE8AWe0F5QxfCdeW6HK4WfMzUTWTTbTtp6
 HzHz73OtACRsFWmtNSsY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 21 April 2012, Alexander Shiyan wrote:
> 
> Added register definitions specific to EP7312 and the necessary
> configuration options.
> 
> Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
> ---
>  arch/arm/include/asm/hardware/ep7312.h         |  106 ++++++++++++++++++++++++
>  arch/arm/mach-clps711x/Kconfig                 |    9 ++-
>  arch/arm/mach-clps711x/include/mach/hardware.h |    4 +
>  drivers/net/irda/Kconfig                       |    3 +-
>  4 files changed, 119 insertions(+), 3 deletions(-)
>  create mode 100644 arch/arm/include/asm/hardware/ep7312.h

I'm missing some historical background here. Why are these files in asm/hardware
rather than in mach/? Should we move them to the platform directory?

	Arnd

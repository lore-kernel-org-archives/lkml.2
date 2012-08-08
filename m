Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932963Ab2HHTOe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 15:14:34 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:50078 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932871Ab2HHTOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 15:14:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH 3/6] ARM: sa1100: include asm/io.h in hackkit leds code
Date: Wed, 8 Aug 2012 17:17:47 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        linux-kernel@vger.kernel.org
References: <1344430493-5304-1-git-send-email-arnd@arndb.de> <1344430493-5304-4-git-send-email-arnd@arndb.de> <20120808153655.GN18957@n2100.arm.linux.org.uk>
In-Reply-To: <20120808153655.GN18957@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208081717.47747.arnd@arndb.de>
X-Provags-ID: V02:K0:bt3XAM5FQa5FxqSlvbvPVHELGL7dp+C0WD/xSaGOGz1
 rmda49VdLAVbJrXJfO2XTJlSajCn97tuTyGsTVWhgrFH+cWYyX
 c5/zTurzzfTKJwLq+ABdQKo39cOyJk0TnWedmIqF281u8KSC/0
 v8HOtaQzbc6DLMxFluvAsMbiZCNCT2rli+8rbMLT0QRt3RThGw
 k5aNz1VUFO3TI+Yk8lF6cUNLaI/nvhSstb4ujAD9tFyQ5NWe+k
 dmqThfB91Ir3INw8nazPuBJyR/YXEiZOPiUoTMQoumbRgeqINJ
 ixYKboVJZ2agCx824QVC49XzQqM5Apq5B0scx8p7YC3NXca08k
 mrt6P/LvtZSOGAuhizwo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 August 2012, Russell King - ARM Linux wrote:
> On Wed, Aug 08, 2012 at 02:54:50PM +0200, Arnd Bergmann wrote:
> > The sa1100 definition of the io_p2v macro has changed in v3.6, and this one
> > file stopped working because of that.
> > 
> > Without this patch, building hackkit_defconfig results in:
> > 
> > arch/arm/mach-sa1100/leds-hackkit.c: In function 'hackkit_leds_event':
> > arch/arm/mach-sa1100/leds-hackkit.c:39:4: error: implicit declaration of function 'IOMEM' [-Werror=implicit-function-declaration]
> 
> NAK.  Should be linux/io.h


Right, fixed now.

Thanks for having a look over this!

	Arnd


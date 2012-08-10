Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760223Ab2HJLEL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 07:04:11 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:52643 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760193Ab2HJLEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 07:04:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH 09/10] ARM: rpc: Fix building RiscPC
Date: Fri, 10 Aug 2012 11:03:58 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        linux-kernel@vger.kernel.org
References: <1344461278-28245-1-git-send-email-arnd@arndb.de> <1344461278-28245-10-git-send-email-arnd@arndb.de> <20120809074754.GP18957@n2100.arm.linux.org.uk>
In-Reply-To: <20120809074754.GP18957@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208101103.58808.arnd@arndb.de>
X-Provags-ID: V02:K0:PpFTdu/FY9tWgxjbHbrKEBvIdTfnDlQeP0bdSH2deTJ
 /dlc2Yzpmaodqww3tNUa5AdUOB1xHcx/3dTAO6pGnv66o1SFJo
 65ynbXoP3IX51MBVqq5Ch1IBZdMsuI9sPBaQ0HcgbNxVunNgl/
 r1z7b41jZl5TmPnxDf+ImY922sKs3ooEoAHAaVALb6C8RKSuA4
 y8azeyPlHmz+oKx+5gdtmf1WxK0QhsruXoxKnq97X4zVmeh82E
 mZyPXspm6bd/jQ0KcGzFs9tP3Vi8FEO06Y/FHJx3unSjqECXce
 hah7bkT5KjVBDSY6N6QwmCf7VOjlpVAwfcmk3REvyrB1zTXLvI
 qI2/az+jm4Ey7qbOGY+4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 August 2012, Russell King - ARM Linux wrote:
> On Wed, Aug 08, 2012 at 11:27:57PM +0200, Arnd Bergmann wrote:
> > ARMv3 support was removed in 357c9c1f07 "ARM: Remove support for ARMv3
> > ARM610 and ARM710 CPUs", which explicitly left parts of the CPU32v3
> > support in place for building RiscPC. However, this does not actually
> > build in my test setup.
> > 
> > This is probably not the right solution, but maybe someone has a better
> > idea for how to deal with this.
> 
> This isn't the right solution.  The RiscPC bus does not support half-word
> load/stores, so we must continue to build that target for the 32v3
> architecture (which is why I carefully left that stuff behind.)
> 
> The mistake is in what I did with arch/arm/lib - the armv3 code in there
> needs to be resurected instead.

Ok, I'll drop my patch from the series then and wait for you to
fix this properly.

	Arnd

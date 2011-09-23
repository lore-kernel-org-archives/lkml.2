Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790Ab1IWDCs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 23:02:48 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36226 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754700Ab1IWDCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 23:02:46 -0400
MIME-Version: 1.0
In-Reply-To: <1316697473.6704.4.camel@phoenix>
References: <1316697473.6704.4.camel@phoenix>
From: Wan ZongShun <mcuos.com@gmail.com>
Date: Fri, 23 Sep 2011 11:02:24 +0800
Message-ID: <CAKT61h95WFp=zdyW=TyVcnTpDOyR_avrkcfSH4JetXYa3efCyA@mail.gmail.com>
Subject: Re: [linux-next next-20110922] build failure due to missing arch/arm/mach-nuc93x/Kconfig
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Russell King <rmk+kernel@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/9/22 Axel Lin <axel.lin@gmail.com>:
> I got below error with today's linux-next tree (next-20110922).
>
> $ make menuconfig
> scripts/kconfig/mconf Kconfig
> arch/arm/Kconfig:972: can't open file "arch/arm/mach-nuc93x/Kconfig"
> make[1]: *** [menuconfig] Error 1
> make: *** [menuconfig] Error 2
>

I I remembered that mach-nuc93x has been removed from Linux mainline, right?

So maybe it reasons from the git merge issue.

> Regards,
> Axel
>
>



-- 
Wan ZongShun.
www.mcuos.com

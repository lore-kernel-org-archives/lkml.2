Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933970Ab2HWNba (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 09:31:30 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:61998 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933202Ab2HWNb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 09:31:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [PATCH 4/4] [RFC] ARM: treewide: manually change more mach-*/*.h includes
Date: Thu, 23 Aug 2012 13:31:09 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
References: <201208221253.07278.arnd@arndb.de> <201208231135.11688.arnd@arndb.de> <50362417.9070600@atmel.com>
In-Reply-To: <50362417.9070600@atmel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208231331.09612.arnd@arndb.de>
X-Provags-ID: V02:K0:1js49YDECw6s+1+wFhCODv7sBrEwxBvOmGJfr3ctDms
 B6yL1f3kBSuA7aS1LkZw9xJsDd0BTYysz24ovQajS8qeJNNE9D
 d2tLsyZyxRGrdlc0xtHkIYA5e7IGLNLqjbz1SEc5c0EOuCf8OR
 iNrwSLGhY8KVNycQ68Eln0NbKqzJLj9hom9chT079Ai9ZErMeB
 r3Su8vcxxnN18S1XrFImcV8lOZj5ZnKdLG++agqVvMQ5zp3xr1
 2VTIiHK6pRLGKm3NrsAHR7tYblkn0QeMS4uRB+LxowO6CjOGux
 v4aov56Xh32px5hFsijzYIGtKgjK0+ypOZg+/d3mbPrNiofvkX
 W//KOt4znHppGgbW3LB8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 23 August 2012, Nicolas Ferre wrote:
> > How about I move all the pure platform data definition files now and
> > rebase the other patches on top of that. Here is a list of suggested
> > file names in include/linux/platform_data/:
> > 
> > mach-at91/at_hdmac.h          -> dma-atmel.h
> 
> Fine with me. Maybe atmel-dma.h can better match what we already have in
> this directory, but I do not know what is the policy in this directory...

There does not seem to be a clear policy in that directory yet, so I
chose to put the subsystem name first. There have been a few subsystems
recently which adopted this naming scheme for their drivers, so it
seemed to be a good choice if we want to start a naming scheme that
sticks.
 
> > ** list of mach/* inclusions that I could not match with
> > ** exactly one ARM platform:
> 
> In fact, for "*atmel*" type of files, they usually match both AVR32
> and ARM/AT91 devices: so, we have to be careful about them...

Yes, I'm aware of that. My list did not include the mach/atmel-mci.h
or the mach/board.h files, which suffer from this problem and cannot
easily be merged.

	Arnd

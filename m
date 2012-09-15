Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab2IOICV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2012 04:02:21 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:59943 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474Ab2IOICM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2012 04:02:12 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Ryan Mallon <rmallon@gmail.com>
Subject: Re: [PATCH 04/24] ARM: ep93xx: use __iomem pointers for MMIO
Date: Sat, 15 Sep 2012 07:55:17 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Nicolas Pitre <nico@linaro.org>,
        Hartley Sweeten <hsweeten@visionengravers.com>
References: <1347658492-11608-1-git-send-email-arnd@arndb.de> <1347658492-11608-5-git-send-email-arnd@arndb.de> <5053AC44.1030909@gmail.com>
In-Reply-To: <5053AC44.1030909@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209150755.18188.arnd@arndb.de>
X-Provags-ID: V02:K0:nETL5XDQm5vAz/Mu3Shz1a1mW3TFloFvs9gbkXT+XQm
 H9lCO8aZ9eTk5uGuVMMBjoJVfppi8C3m9NWBlnJqOVpFeSSuP7
 PFJKPJY8/zRlSIr3W+awWbmoEzpKJZaOQvZNjdJCiU0hCgRwzx
 J8k4ti/a3xoaZQvWpfCDsBY2KuvquVNbDvU8sNgGAXBFqn2FLn
 5xo5t50nnX2kJoamSk+4E89x4NJ79BfQYG352/CI6oaXpVU/fH
 xu2p6wVHoqDjBGopxZ2HuUzPxrstuuHEN8UohdwLkH/enyK7vN
 OyIyC28zbN5AQZn2WDJ5UG+SMN8zTIRpgynuCCi6mG7qIecq4Q
 X1pLB2sn0Xjg0aqwT7QQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 September 2012, Ryan Mallon wrote:
> On 15/09/12 07:34, Arnd Bergmann wrote:
> 
> > ARM is moving to stricter checks on readl/write functions,
> > so we need to use the correct types everywhere.
> > 
> > Cc: Hartley Sweeten <hsweeten@visionengravers.com>
> > Cc: Ryan Mallon <rmallon@gmail.com>
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 
> 
> Hi Arnd,
> 
> Do you want me to queue both this and my patch to move the 
> ts72xx.h header into arch/arm/mach-ep93xx on to my ep93xx-fixes
> branch? That way you won't have to deal with any conflicts at
> your end.
> 

Yes, that would be great, thanks!

	Arnd


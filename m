Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041Ab1GXIBG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 04:01:06 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:62982 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591Ab1GXIBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 04:01:00 -0400
Subject: Re: [PATCH] ARM:mach-dove:remove the dup include serial_8250.h
From: Wanlong Gao <wanlong.gao@gmail.com>
Reply-To: wanlong.gao@gmail.com
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Wanlong Gao <gaowanlong@cn.fujitsu.com>
In-Reply-To: <alpine.LNX.2.00.1107240950550.5758@swampdragon.chaosbits.net>
References: <1311477872-4329-1-git-send-email-wanlong.gao@gmail.com>
	 <alpine.LNX.2.00.1107240950550.5758@swampdragon.chaosbits.net>
Content-Type: text/plain; charset="UTF-8"
Organization: fujitsu
Date: Sun, 24 Jul 2011 16:00:54 +0800
Message-ID: <1311494454.2102.0.camel@Tux>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 日, 2011-07-24 at 09:51 +0200, Jesper Juhl wrote:
> On Sun, 24 Jul 2011, Wanlong Gao wrote:
> 
> > From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
> > 
> > linux/serial_8250.h has been included for twice.
> > 
> > Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
> > ---
> >  arch/arm/mach-dove/common.c |    1 -
> >  1 files changed, 0 insertions(+), 1 deletions(-)
> > 
> > diff --git a/arch/arm/mach-dove/common.c b/arch/arm/mach-dove/common.c
> > index 5ed51b8..b6c3d6b 100644
> > --- a/arch/arm/mach-dove/common.c
> > +++ b/arch/arm/mach-dove/common.c
> > @@ -17,7 +17,6 @@
> >  #include <linux/clk.h>
> >  #include <linux/mbus.h>
> >  #include <linux/ata_platform.h>
> > -#include <linux/serial_8250.h>
> >  #include <linux/gpio.h>
> >  #include <asm/page.h>
> >  #include <asm/setup.h>
> > 
> 
> A patch for this is already in linux-next: 
> http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=commitdiff;h=4ca9d7856c101f4b1d2c7d3f2ad2fcce8e9a20ae
> "ARM: remove duplicate include from arch/arm/mach-dove/common.c"
cheers.
> 



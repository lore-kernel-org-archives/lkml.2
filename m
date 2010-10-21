Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604Ab0JUAc2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 20:32:28 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:48313 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab0JUAc1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 20:32:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=jdSyBGGcQbKT/gw+brwyaPfFd0HCjX7YdSrzWoW8H1xZOSLUGmSfe0CAdI48Lsjb6I
         14ZA4XEiH5E82NQ8CUl4RFDXidWSc6G2wG+kCarLeuTANWkOMEE00N/17SB35FfQbkWz
         K5k4BcbwBdxH0OIGhfo84OYHPmQJIi6ujBOmA=
MIME-Version: 1.0
In-Reply-To: <AANLkTim+vj_OAd22TdThuC-HSqUiDjguOHQWjyqFaq6N@mail.gmail.com>
References: <AANLkTim+vj_OAd22TdThuC-HSqUiDjguOHQWjyqFaq6N@mail.gmail.com>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Thu, 21 Oct 2010 08:32:06 +0800
Message-ID: <AANLkTi=Cpq2_vV2RGcoQhrqk8xpL59AvLFPzfvTBk5Xa@mail.gmail.com>
Subject: Re: [RFC] Removal of dead code from arch/arm/*
To: Zimny Lech <napohybelskurwysynom2010@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 21, 2010 at 8:23 AM, Zimny Lech
<napohybelskurwysynom2010@gmail.com> wrote:
> Hi,
>
> I will begin testing this, I would like to know your opinion about this patches
> git pull git://github.com/napohybelskurwysynom2010/Linux-2.6-nps.git rodc1

Would be great if you can post the patches instead of letting people
figuring out
how to peek into your changes? (although a combination of "git remote add" +
"git fetch" + "git log <your remote branch>" can do the trick, not that straight
forward)

>
>  arch/arm/kernel/time.c                       |    6 +-
>  arch/arm/mach-omap1/board-sx1.c              |   27 -
>  arch/arm/mach-omap1/pm.c                     |    7 -
>  arch/arm/mach-s3c2410/include/mach/gpio.h    |    4 -
>  arch/arm/mach-s3c2443/mach-smdk2443.c        |    8 -
>  arch/arm/mach-sa1100/include/mach/SA-1101.h  |  925 --------------------------
>  arch/arm/mach-sa1100/include/mach/hardware.h |    4 -
>  arch/arm/mach-u300/clock.c                   |   91 ---
>  arch/arm/plat-mxc/include/mach/mx51.h        |    4 -
>  arch/m32r/kernel/time.c                      |    6 +-
>  drivers/acpi/proc.c                          |    2 +-
>  11 files changed, 3 insertions(+), 1081 deletions(-)
>
>
> --
> Slawa!
> N.P.S.
>
> Les fleurs du mal unfold
> Comme les fleurs du mal
> Dark demons of my soul
> Un amour fatal
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>

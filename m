Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525Ab1E2Jy1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 05:54:27 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:56179 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915Ab1E2Jy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 05:54:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Ihw19zZwMaGwZAh8VqS7s8NROnZ1qKF/KGOYKTh6kbaDxuW6bjrIORtLpWpSI8Jibj
         ULNmqKHgKMX9Kl9ldNz4wYvJ3jye7SS1wYNR1UZzx0kydpPgM6EllIUMzU07/dwItOhh
         37HvUGFoOPvWMgN75bWBM3aXXp1iGR6WtmfsM=
MIME-Version: 1.0
In-Reply-To: <201105291122.01602.toralf.foerster@gmx.de>
References: <201105291122.01602.toralf.foerster@gmx.de>
Date: Sun, 29 May 2011 11:54:25 +0200
Message-ID: <BANLkTi=NTWo3AyVUA93=bBcjKeSfbsQBcQ@mail.gmail.com>
Subject: Re: 2 small kernel config issues related to UML + RTC
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: =?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p4T9sa9C027398

2011/5/29 Toralf Förster <toralf.foerster@gmx.de>:
> Hello,
>
> with the current git kernel I run
> $>make ARCH=um menuconfig
>
> and searched for the string "RTC" b/c during boot of my UML image I realized nowadays the message:
>
> "Kernel not built with RTC support, ALARM timers will not wake from suspend"
>
> Although the menuconfig gives me the answer :
>
>  │ Symbol: STMMAC_RTC_TIMER [=n]                                                                                   │
>  │ Type  : boolean                                                                                                 │
>  │ Prompt: Real time clock                                                                                         │
>  │   Defined at drivers/net/stmmac/Kconfig:50                                                                      │
>  │   Depends on: <choice> && RTC_CLASS                                                                             │
>  │   Location:                                                                                                     │
>  │     -> Network device support (NETDEVICES [=y])                                                                 │
>  │       -> Ethernet (1000 Mbit) (NETDEV_1000 [=n])                                                                │
>  │         -> STMicroelectronics 10/100/1000 Ethernet driver (STMMAC_ETH [=n])                                     │
>  │           -> STMMAC Timer optimisation (STMMAC_TIMER [=n])                                                      │
>  │             -> Select Timer device (<choice> [=n])                                                              │
>
>
> I cannot found the menu item.
>
> To sum it up IMO the kernel mesage doesn't makes sense for UML
> and furthermore searching for "RTC" shouldn't give non-existent menu items, isn't it ?

I saw this message too.
A fix is on the way...

-- 
Thanks,
//richard
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�

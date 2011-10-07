Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965187Ab1JGJ5n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 05:57:43 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:57802 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965051Ab1JGJ5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 05:57:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Eric Miao <eric.y.miao@gmail.com>
Subject: Re: [PATCH 11/26] ARM: pxa: allow building palm27x without pxafb
Date: Fri, 7 Oct 2011 11:57:34 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jason Chagas <jason.chagas@marvell.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Marek Vasut <marek.vasut@gmail.com>
References: <1317499438-14058-1-git-send-email-arnd@arndb.de> <1317499438-14058-12-git-send-email-arnd@arndb.de> <CAMPhdO_bKPxEEmBzSKvgYooG5YwweSYJVMdCxwYtQKJMyiWggg@mail.gmail.com>
In-Reply-To: <CAMPhdO_bKPxEEmBzSKvgYooG5YwweSYJVMdCxwYtQKJMyiWggg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201110071157.34222.arnd@arndb.de>
X-Provags-ID: V02:K0:wly3AnF6u57K15qRILxRikrSwTDJXUQgMgZ9TpbiEsr
 KXMYzFKWxdPgHwsTB6ZAtgucIayi0Jp+nAV15u77Tds5jMSSls
 jx0YmjLy3D7y0QeN6zb27qLarDrsEcIWdzTG8bxGJVg1mpKx4Z
 /JuU1b4j53d7k3BABIOTEMG6BtaX3o0NseXy49kYLuxpyZHWDV
 KLp8rMLzRgcEBlV6jHBUa6Iqo8o5oTMfhrzXFQQJ+Z6ds0hwBc
 4uB9Dh4iGEdpOA0s4GWsed8rZ7GGPb7i76PiTgplfjSJrvmjgE
 EcyfCAyrTJdYGxeEn2PIQCXDp0s0B98WfF9eMKw+2NYQR/7sLM
 lnvch0w9GUNGPV6g7+oI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 October 2011, Eric Miao wrote:
> Marek and I actually came up with a patch to fix this as below, this
> way to cover the declarations of those modes in the CONFIG_FB_PXA
> as well.
> 
> commit e227e88ae46e921f608b056e27e1d8704b7d12fa
> Author: Eric Miao <eric.y.miao@gmail.com>
> Date:   Sun Sep 11 16:56:58 2011 +0800
> 
>     ARM: pxa: fix building error by palm27x_lcd_init() when FB_PXA not defined
> 
>     Cc: Marek Vasut <marek.vasut@gmail.com>
>     Signed-off-by: Eric Miao <eric.y.miao@gmail.com>

Yes, that looks better than my solution

	Arnd

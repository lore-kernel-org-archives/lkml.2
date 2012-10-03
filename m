Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094Ab2JCLXe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 07:23:34 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:55201 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855Ab2JCLXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 07:23:33 -0400
X-Auth-Info: B3NM6OsP+eSy2eNER6Ies1fN7gicq3kFdM1Rev/aEvw=
From: Marek Vasut <marex@denx.de>
To: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 04/17] ARM: pxa: define palmte2_pxa_keys conditionally
Date: Wed, 3 Oct 2012 13:23:23 +0200
User-Agent: KMail/1.13.7 (Linux/3.4-trunk-amd64; KDE/4.8.4; x86_64; ; )
Cc: linux-arm-kernel@infradead.org, arm@kernel.org,
        linux-kernel@vger.kernel.org,
        Carlos Eduardo Medaglia Dyonisio <cadu@nerdfeliz.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com>
References: <1349195816-2225-1-git-send-email-arnd@arndb.de> <1349195816-2225-5-git-send-email-arnd@arndb.de>
In-Reply-To: <1349195816-2225-5-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201210031323.23833.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Arnd Bergmann,

> Gcc prints a harmless warning about palmte2_pxa_keys not being used
> when the gpio keyboard driver is disabled. The solution is to use
> the same #ifdef that is already present in the place where the
> symbol is used.
> 
> Without this patch, building palmz72_defconfig results in:
> 
> /home/arnd/linux-arm/arch/arm/mach-pxa/palmte2.c:128:31: warning:
> 'palmte2_pxa_keys' defined but not used [-Wunused-variable]
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Marek Vasut <marek.vasut@gmail.com>
> Cc: Carlos Eduardo Medaglia Dyonisio <cadu@nerdfeliz.com>
> Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
> Cc: Eric Miao <eric.y.miao@gmail.com>

Acked-by: Marek Vasut <marex@denx.de>

Thanks Arnd

Best regards,
Marek Vasut

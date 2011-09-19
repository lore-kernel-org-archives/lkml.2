Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775Ab1ISIpT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 04:45:19 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:43499 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834Ab1ISIpR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 04:45:17 -0400
MIME-Version: 1.0
In-Reply-To: <1315383059-3673-37-git-send-email-yong.zhang0@gmail.com>
References: <1315383059-3673-1-git-send-email-yong.zhang0@gmail.com> <1315383059-3673-37-git-send-email-yong.zhang0@gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Mon, 19 Sep 2011 16:44:55 +0800
Message-ID: <CAGsJ_4z8_zx3dATD+F8A0Krw0N0REBTdzD3NiHFOU9P5h0Reuw@mail.gmail.com>
Subject: Re: [PATCH 36/62] i2c: irq: Remove IRQF_DISABLED
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, Dave Airlie <airlied@linux.ie>,
        linux-i2c@vger.kernel.org, Sonic Zhang <sonic.zhang@analog.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Joe Perches <joe@perches.com>,
        mingo@elte.hu, "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
        Alessandro Rubini <rubini@unipv.it>,
        Nobuhiro Iwamatsu <iwamatsu@nigauri.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Magnus Damm <damm@opensource.se>, Simon Horman <horms@verge.net.au>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        tglx@linutronix.de, linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@stericsson.com>,
        Jiri Kosina <jkosina@suse.cz>, Paul Mundt <lethal@linux-sh.org>,
        STEricsson <STEricsson_nomadik_linux@list.st.com>,
        uclinux-dist-devel@blackfin.uclinux.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/9/7 Yong Zhang <yong.zhang0@gmail.com>:
> This flag is a NOOP and can be removed now.
>
> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>

Acked-by: Barry Song <21cnbao@gmail.com>

> ---
>  drivers/i2c/busses/i2c-bfin-twi.c   |    4 ++--
>  drivers/i2c/busses/i2c-designware.c |    2 +-
>  drivers/i2c/busses/i2c-highlander.c |    2 +-
>  drivers/i2c/busses/i2c-nomadik.c    |    2 +-
>  drivers/i2c/busses/i2c-nuc900.c     |    2 +-
>  drivers/i2c/busses/i2c-pmcmsp.c     |    2 +-
>  drivers/i2c/busses/i2c-s3c2410.c    |    2 +-
>  drivers/i2c/busses/i2c-sh7760.c     |    2 +-
>  drivers/i2c/busses/i2c-sh_mobile.c  |    2 +-
>  drivers/i2c/busses/i2c-stu300.c     |    2 +-
>  10 files changed, 11 insertions(+), 11 deletions(-)

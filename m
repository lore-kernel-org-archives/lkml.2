Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965076Ab2JLQIk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 12:08:40 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:38831 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964886Ab2JLQIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 12:08:38 -0400
MIME-Version: 1.0
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F641766E4@DQHE02.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998F641766E4@DQHE02.ent.ti.com>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Sat, 13 Oct 2012 00:08:16 +0800
X-Google-Sender-Auth: Paz0rZ5rvawXlP9FOFHuefqDhYs
Message-ID: <CAK5ve-LywCDiBLPwYThPBC_xi=3hb+Xb1E1PTfWKncuuXZ56+Q@mail.gmail.com>
Subject: Re: [PATCH 00/28] leds: add common driver for LP5521/5523/55231
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: Richard Purdie <rpurdie@rpsys.net>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the delay. These days I'm moving and I will review this
patchset after I settle down.

Thanks a lot,
-Bryan

On Fri, Oct 5, 2012 at 4:09 PM, Kim, Milo <Milo.Kim@ti.com> wrote:
>  LP5521, LP5523 and L55231 have common features as below.
>
>  Register access via the I2C.
>  Device initialization/de-initialization.
>  Create LED class devices for multiple output channels.
>  Device attributes for user-space interface.
>
>  Therefore, this series of patch set enables removing duplicate code for
>  lp5521/5523 driver and making coherent driver structure.
>
>  All patches have been tested in LP5521, LP5523 and LP55231 boards.
>
> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
> Tested-by: Milo(Woogyom) Kim <milo.kim@ti.com>
> ---
>  Documentation/leds/00-INDEX                  |    2 +
>  Documentation/leds/leds-lp5521.txt           |   63 +-
>  Documentation/leds/leds-lp5523.txt           |   27 +-
>  Documentation/leds/leds-lp55xx.txt           |  104 +++
>  arch/arm/mach-omap2/board-rx51-peripherals.c |    8 +-
>  arch/arm/mach-ux500/board-mop500.c           |   14 +-
>  drivers/leds/Kconfig                         |   15 +-
>  drivers/leds/Makefile                        |    1 +
>  drivers/leds/leds-lp5521.c                   |  928 +++++++---------------
>  drivers/leds/leds-lp5523.c                   | 1065 +++++++-------------------
>  drivers/leds/leds-lp55xx-common.c            |  516 +++++++++++++
>  drivers/leds/leds-lp55xx-common.h            |  138 ++++
>  include/linux/leds-lp5521.h                  |   73 --
>  include/linux/leds-lp5523.h                  |   49 --
>  include/linux/platform_data/leds-lp55xx.h    |   55 ++
>  15 files changed, 1374 insertions(+), 1684 deletions(-)
>  create mode 100644 Documentation/leds/leds-lp55xx.txt
>  create mode 100644 drivers/leds/leds-lp55xx-common.c
>  create mode 100644 drivers/leds/leds-lp55xx-common.h
>  delete mode 100644 include/linux/leds-lp5521.h
>  delete mode 100644 include/linux/leds-lp5523.h
>  create mode 100644 include/linux/platform_data/leds-lp55xx.h
>
> Best Regards,
> Milo
>
>



-- 
Bryan Wu <bryan.wu@canonical.com>
Kernel Developer    +86.186-168-78255 Mobile
Canonical Ltd.      www.canonical.com
Ubuntu - Linux for human beings | www.ubuntu.com

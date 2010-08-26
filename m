Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300Ab0HZKQ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 06:16:29 -0400
Received: from compulab.co.il ([67.18.134.219]:52214 "EHLO compulab.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752000Ab0HZKQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 06:16:27 -0400
Message-ID: <4C763EC0.10807@compulab.co.il>
Date: Thu, 26 Aug 2010 13:15:28 +0300
From: Mike Rapoport <mike@compulab.co.il>
User-Agent: Thunderbird 2.0.0.23 (X11/20100106)
MIME-Version: 1.0
To: Arun Murthy <arun.murthy@stericsson.com>
CC: sameo@linux.intel.com, riku.voipio@iki.fi, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Mike Rapoport <mike@compulab.co.il>
Subject: Re: [PATCH 0/3] u8500: led and backlight driver
References: <1282805432-28523-1-git-send-email-arun.murthy@stericsson.com>
In-Reply-To: <1282805432-28523-1-git-send-email-arun.murthy@stericsson.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ACL-Warn: {
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - compulab.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arun Murthy wrote:
> Arun Murthy (3):
>   mfd: ab8500-pwm: ab8500 pwm management
>   backlight: u8500: backlight driver based on ab8500 pwm
>   leds: ab8500-led: led driver based on ab8500 pwm

There are drivers/leds/leds-pwm.c and drivers/video/backlight/pwm_bl.c that 
implement led and backlight drivers based on generic pwm interface.
Have you considered using those?

>  drivers/leds/Kconfig                  |    9 ++
>  drivers/leds/Makefile                 |    1 +
>  drivers/leds/leds-ab8500.c            |  201 +++++++++++++++++++++++++++++++
>  drivers/mfd/Kconfig                   |    8 ++
>  drivers/mfd/Makefile                  |    1 +
>  drivers/mfd/ab8500-core.c             |    7 +-
>  drivers/mfd/ab8500-pwm.c              |  191 ++++++++++++++++++++++++++++++
>  drivers/video/backlight/Kconfig       |   10 ++
>  drivers/video/backlight/Makefile      |    2 +-
>  drivers/video/backlight/ab8500_bl.c   |  209 +++++++++++++++++++++++++++++++++
>  include/linux/mfd/ab8500.h            |    5 +
>  include/linux/mfd/abx500/ab8500-pwm.h |   32 +++++
>  12 files changed, 674 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/leds/leds-ab8500.c
>  create mode 100644 drivers/mfd/ab8500-pwm.c
>  create mode 100644 drivers/video/backlight/ab8500_bl.c
>  create mode 100644 include/linux/mfd/abx500/ab8500-pwm.h
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
Sincerely yours,
Mike.

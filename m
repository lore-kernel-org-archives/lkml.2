Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506Ab1E3IyO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 04:54:14 -0400
Received: from smtp.nokia.com ([147.243.1.48]:26287 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751041Ab1E3IyN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 04:54:13 -0400
Subject: Re: [PATCH 0/2] Support for the ST-Ericsson HSI controller
From: Carlos Chinea <carlos.chinea@nokia.com>
To: ext Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Pawel Szyszuk <pawel.szyszuk@stericsson.com>
In-Reply-To: <1306340839-31331-1-git-send-email-linus.walleij@stericsson.com>
References: <1306340839-31331-1-git-send-email-linus.walleij@stericsson.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 May 2011 11:50:39 +0300
Message-ID: <1306745439.2819.10050.camel@groo>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Wed, 2011-05-25 at 18:27 +0200, ext Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> Hi Carlos,
> 
> here is the pending patch to add support for ST-Ericssons HSI controller
> in your new HSI subsystem.
> 
> It would be great if you could carry this as part of the HSI patchset until
> it gets merged so you have full control over it, but I think we need to
> split out the <mash/hsi.h> file from the second patch and put it into
> the hsi include dir first for that.
> 

I will be glad to carry this patches with the HSI patchset. I'll do a
review asap. As first comment I think we can keep mach/hsi.h where it is
as it looks to me that all the code is tight there is tied to the
platform.

> Anyway, take it as a first sign of life and a review opportunity.
> 
> Pawel Szyszuk (2):
>   HSI: add ST-E HSI controller
>   mach-ux500: platform data for ST-E HSI controller
> 
>  arch/arm/mach-ux500/board-mop500-pins.c    |   10 +
>  arch/arm/mach-ux500/board-mop500.c         |   65 ++
>  arch/arm/mach-ux500/clock.c                |    8 +-
>  arch/arm/mach-ux500/devices-db8500.c       |  118 +++
>  arch/arm/mach-ux500/include/mach/devices.h |    1 +
>  arch/arm/mach-ux500/include/mach/hsi.h     |  122 +++
>  drivers/hsi/controllers/Kconfig            |   10 +
>  drivers/hsi/controllers/Makefile           |    1 +
>  drivers/hsi/controllers/ste_hsi.c          | 1536 ++++++++++++++++++++++++++++
>  9 files changed, 1867 insertions(+), 4 deletions(-)
>  create mode 100644 arch/arm/mach-ux500/include/mach/hsi.h
>  create mode 100644 drivers/hsi/controllers/ste_hsi.c
> 

Br,
Carlos

-- 
Carlos Chinea <carlos.chinea@nokia.com>


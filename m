Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362Ab1HUOmz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 10:42:55 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51882 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754678Ab1HUOmx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 10:42:53 -0400
MIME-Version: 1.0
In-Reply-To: <1313747619-32222-1-git-send-email-linus.walleij@stericsson.com>
References: <1313747619-32222-1-git-send-email-linus.walleij@stericsson.com>
From: Barry Song <21cnbao@gmail.com>
Date: Sun, 21 Aug 2011 22:42:32 +0800
Message-ID: <CAGsJ_4z7s-ibmUuR1DA6Jps030dRrnE8M0dUWHoMhMPFtyyY_A@mail.gmail.com>
Subject: Re: [PATCH 0/4 v4] pin controller subsystem v4
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Stephen Warren <swarren@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Joe Perches <joe@perches.com>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> - Rewrite the interaction with the GPIO subsystem - the pin
>  controller descriptor now handles this by defining an offset
>  into the GPIO numberspace for its handled pin range. This is
>  used to look up the apropriate pin controller for a GPIO pin.
>  Then that specific GPIO range is matched 1-1 for the target
>  controller instance.
...
>
> Linus Walleij (4):
>  drivers: create a pinmux subsystem v4
>  pinmux: add a driver for the U300 pinmux
>  amba: request muxing for PrimeCell devices
>  mach-u300: activate pinmux driver, delete old padmux driver

it seems there is not an actual example that gpio requests pin from
pinctrl yet. i might give one on SiRFprimaII.

Thanks
Barry

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758536Ab1EZXZf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 19:25:35 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:56928 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754820Ab1EZXZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 19:25:34 -0400
Date: Thu, 26 May 2011 17:25:18 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 0/4] Move U300 and Nomadik GPIO drivers v2
Message-ID: <20110526232518.GA1384@ponder.secretlab.ca>
References: <1306271192-28911-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306271192-28911-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 11:06:32PM +0200, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> This is a rebase of the earlier patch set, due to updates
> pulled in to Torvalds tree conflicting with earlier movement
> patches.
> 
> I also used -M so we can see what is happening, yay!

Applied whole series, plus the kconfig fixup.  Thanks.

g.

> 
> Linus Walleij (2):
>   gpio: move U300 GPIO driver to drivers/gpio
>   gpio: move Nomadik GPIO driver to drivers/gpio
> 
> Rabin Vincent (1):
>   gpio/nomadik: show all pins in debug
> 
> Rickard Andersson (1):
>   gpio/nomadik: add function to read GPIO pull down status
> 
>  arch/arm/mach-u300/Makefile                        |    2 +-
>  arch/arm/plat-nomadik/Kconfig                      |    5 --
>  arch/arm/plat-nomadik/Makefile                     |    1 -
>  arch/arm/plat-nomadik/include/plat/gpio.h          |    2 +
>  drivers/gpio/Makefile                              |    2 +
>  .../gpio.c => drivers/gpio/gpio-nomadik.c          |   65 +++++++++++++++++---
>  .../mach-u300/gpio.c => drivers/gpio/gpio-u300.c   |    0
>  7 files changed, 62 insertions(+), 15 deletions(-)
>  rename arch/arm/plat-nomadik/gpio.c => drivers/gpio/gpio-nomadik.c (95%)
>  rename arch/arm/mach-u300/gpio.c => drivers/gpio/gpio-u300.c (100%)
> 
> -- 
> 1.7.3.2
> 

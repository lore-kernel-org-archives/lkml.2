Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932609Ab2HHPYo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 11:24:44 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:45929 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932396Ab2HHPYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 11:24:42 -0400
MIME-Version: 1.0
In-Reply-To: <1344430493-5304-3-git-send-email-arnd@arndb.de>
References: <1344430493-5304-1-git-send-email-arnd@arndb.de>
	<1344430493-5304-3-git-send-email-arnd@arndb.de>
Date: Wed, 8 Aug 2012 23:24:40 +0800
Message-ID: <CAN1soZwzSVe2VrTOod0ZtwF9UUS7fPYSt6Vkqgg4-6csUB3mqw@mail.gmail.com>
Subject: Re: [PATCH 2/6] ARM: pxa remove irq_to_gpio from eeti_ts driver
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        linux-kernel@vger.kernel.org, "v3.2+" <stable@vger.kernel.org>,
        Daniel Mack <zonque@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 8, 2012 at 8:54 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> The irq_to_gpio function was removed from the pxa platform
> in linux-3.2, and this driver has been broken since.
>
> Without this patch, building raumfeld_defconfig results in:
>
> drivers/input/touchscreen/eeti_ts.c: In function 'eeti_ts_irq_active':
> drivers/input/touchscreen/eeti_ts.c:65:2: error: implicit declaration of function 'irq_to_gpio' [-Werror=implicit-function-declaration]
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: stable@vger.kernel.org (v3.2+)
> Cc: Daniel Mack <zonque@gmail.com>
> Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
> ---
>  arch/arm/mach-pxa/raumfeld.c        |    1 +
>  drivers/input/touchscreen/eeti_ts.c |    8 +++++---
>  include/linux/input/eeti_ts.h       |    1 +
>  3 files changed, 7 insertions(+), 3 deletions(-)
>

Acked-by: Haojian Zhuang <haojian.zhuang@gmail.com>

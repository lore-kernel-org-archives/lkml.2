Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059Ab2LASpy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 13:45:54 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:38624 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825Ab2LASpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 13:45:52 -0500
MIME-Version: 1.0
In-Reply-To: <1354276654-590-1-git-send-email-lee.jones@linaro.org>
References: <1354276654-590-1-git-send-email-lee.jones@linaro.org>
Date: Sat, 1 Dec 2012 19:45:51 +0100
Message-ID: <CACRpkdZpZWF7-VpQumsgdhZ_ox7DQHr+61L8KOPH6tqcK89bkg@mail.gmail.com>
Subject: Re: [PATCH 00/12] Refactoring the ab8500 battery management drivers
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, linus.walleij@stericsson.com, arnd@arndb.de,
        cbou@mail.ru, dwmw2@infradead.org, rajanikanth.hv@linaro.org,
        Arun MURTHY <arun.murthy@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2012 at 12:57 PM, Lee Jones <lee.jones@linaro.org> wrote:

> The aim of this and subsequent patch-sets is to refactor battery
> management services provided by the ab8500 MFD. This first patch-set
> brings a few modifications to the collection which happened on the
> internal kernel, but were never Mainlined. There are lots more of
> these to come. We also tidy-up some of the Device Tree related patches
> which are currently pending in -next.
>
>  drivers/mfd/ab8500-core.c       |    8 -
>  drivers/power/ab8500_bmdata.c   |  517 +++++++++++++++++++--------------------
>  drivers/power/ab8500_btemp.c    |   96 ++++----
>  drivers/power/ab8500_charger.c  |  222 ++++++++++++-----
>  drivers/power/ab8500_fg.c       |  123 +++++-----
>  drivers/power/abx500_chargalg.c |  133 +++++-----
>  include/linux/mfd/abx500.h      |    6 +-
>  7 files changed, 592 insertions(+), 513 deletions(-)

All of this looks good to me.
Acked-by: Linus Walleij <linus.walleij@linaro.org>
for all.

Arun submitted the original driver, maybe he can throw in an
ACK as well...

Yours,
Linus Walleij

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227Ab2FKU4W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 16:56:22 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:45002 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316Ab2FKU4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 16:56:10 -0400
MIME-Version: 1.0
In-Reply-To: <1339428307-3850-3-git-send-email-lee.jones@linaro.org>
References: <1339428307-3850-1-git-send-email-lee.jones@linaro.org>
	<1339428307-3850-3-git-send-email-lee.jones@linaro.org>
Date: Mon, 11 Jun 2012 22:56:09 +0200
Message-ID: <CACRpkdbOYOWi-0gu_4eUZzkZmNw-oVOuVEpdaPqqWSV2rLRoDg@mail.gmail.com>
Subject: Re: [rtc-linux] [PATCH 02/14] rtc: Ensure correct probing of the
 AB8500 RTC when Device Tree is enabled
From: Linus Walleij <linus.walleij@linaro.org>
To: rtc-linux@googlegroups.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, arnd@arndb.de, grant.likely@secretlab.ca,
        Lee Jones <lee.jones@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Mattias WALLIN <mattias.wallin@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2012 at 5:24 PM, Lee Jones <lee.jones@linaro.org> wrote:

> Without this patch, if Device Tree is enabled the AB8500 RTC wouldn't
> get probed at all, as there is no reference to it from platform code.
> This patch ensures the driver is probed during normal DT start-up.
>
> Cc: Alessandro Zummo <a.zummo@towertech.it>
> Cc: rtc-linux@googlegroups.com
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Thanks,
Linus Walleij

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588Ab2GBPXk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 11:23:40 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49406 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753972Ab2GBPXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 11:23:39 -0400
Message-ID: <4FF1BCF6.1090608@linaro.org>
Date: Mon, 02 Jul 2012 16:23:34 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, arnd@arndb.de, grant.likely@secretlab.ca,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com
Subject: Re: [PATCH 02/14] rtc: Ensure correct probing of the AB8500 RTC when
 Device Tree is enabled
References: <1339428307-3850-1-git-send-email-lee.jones@linaro.org> <1339428307-3850-3-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1339428307-3850-3-git-send-email-lee.jones@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/12 16:24, Lee Jones wrote:
> Without this patch, if Device Tree is enabled the AB8500 RTC wouldn't
> get probed at all, as there is no reference to it from platform code.
> This patch ensures the driver is probed during normal DT start-up.
>
> Cc: Alessandro Zummo <a.zummo@towertech.it>
> Cc: rtc-linux@googlegroups.com
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>   drivers/rtc/rtc-ab8500.c |    8 +++++++-
>   1 file changed, 7 insertions(+), 1 deletion(-)

Please don't take this patch now, it was been superseded.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
M: +44 77 88 633 515
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog



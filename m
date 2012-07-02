Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623Ab2GBPYq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 11:24:46 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60821 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696Ab2GBPYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 11:24:45 -0400
Message-ID: <4FF1BD39.8020800@linaro.org>
Date: Mon, 02 Jul 2012 16:24:41 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, arnd@arndb.de, grant.likely@secretlab.ca,
        Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org
Subject: Re: [PATCH 11/14] usb: otg: Enable probing of the ab8500 during a
 Device Tree boot
References: <1339428307-3850-1-git-send-email-lee.jones@linaro.org> <1339428307-3850-12-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1339428307-3850-12-git-send-email-lee.jones@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/12 16:25, Lee Jones wrote:
> Without this patch, if Device Tree is enabled the AB8500 USB OTG driver
> wouldn't get probed at all, as there is no reference to it from platform
> code. This patch ensures the driver is probed during normal DT start-up.
>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: linux-usb@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>   drivers/usb/otg/ab8500-usb.c |    6 ++++++
>   1 file changed, 6 insertions(+)

Please don't take this patch now, it was been superseded.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
M: +44 77 88 633 515
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog



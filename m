Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082Ab2FKVjr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 17:39:47 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:62068 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840Ab2FKVjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 17:39:46 -0400
MIME-Version: 1.0
In-Reply-To: <1339428307-3850-12-git-send-email-lee.jones@linaro.org>
References: <1339428307-3850-1-git-send-email-lee.jones@linaro.org>
	<1339428307-3850-12-git-send-email-lee.jones@linaro.org>
Date: Mon, 11 Jun 2012 23:39:45 +0200
Message-ID: <CACRpkdbJzZRXNqy0wSO4cw0eZCys8YiT=5xnN8E61S+7q+obcQ@mail.gmail.com>
Subject: Re: [PATCH 11/14] usb: otg: Enable probing of the ab8500 during a
 Device Tree boot
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, arnd@arndb.de, grant.likely@secretlab.ca,
        Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2012 at 5:25 PM, Lee Jones <lee.jones@linaro.org> wrote:

> Without this patch, if Device Tree is enabled the AB8500 USB OTG driver
> wouldn't get probed at all, as there is no reference to it from platform
> code. This patch ensures the driver is probed during normal DT start-up.
>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: linux-usb@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Thanks,
Linus Walleij

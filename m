Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023Ab2GEHdv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 03:33:51 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:44110 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853Ab2GEHdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 03:33:50 -0400
Message-ID: <4FF5435A.1000909@linaro.org>
Date: Thu, 05 Jul 2012 08:33:46 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: linux-arm-kernel@lists.infradead.org, linus.walleij@stericsson.com,
        arnd@arndb.de, sameo@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] mfd: Fix runtime warning caused by duplicate device
 registration
References: <1341316788-12730-1-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1341316788-12730-1-git-send-email-lee.jones@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sam,

On 03/07/12 12:59, Lee Jones wrote:
> We register the ab8500 as an MFD device from db8500 code during Device Tree
> boot in order to solve some limitations of DT. However, when Device Tree is
> not enabled, we still want to allow platform code to register the ab8500 in
> the normal way. Here we force MFD device registration of the ab8500 only
> when booting with Device Tree enabled.
>
> Solves this issue:
> WARNING: at fs/sysfs/dir.c:526 sysfs_add_one+0x88/0xb0()
> sysfs: cannot create duplicate filename '/bus/platform/devices/ab8500-core.0'
>
> Reported-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Are you planning on taking this in any time soon? I'd really like to fix 
this bug for Linus in -next.

Kind regards,
Lee

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
M: +44 77 88 633 515
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog



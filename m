Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436Ab2DJRWc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 13:22:32 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39124 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028Ab2DJRWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 13:22:30 -0400
Message-ID: <4F846C53.1070407@samsung.com>
Date: Tue, 10 Apr 2012 10:22:27 -0700
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: grant.likely@secretlab.ca, kgene.kim@samsung.com,
        linus.walleij@stericsson.com, sangsu4u.park@samsung.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] gpio: samsung: refactor gpiolib init for exynos4/5
References: <1333913007-16032-1-git-send-email-olof@lixom.net>
In-Reply-To: <1333913007-16032-1-git-send-email-olof@lixom.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Olof Johansson wrote:
> Only code move, no functional change.
>
> Main reason to do this was to get rid of the warnings:
>
> drivers/gpio/gpio-samsung.c: In function 'samsung_gpiolib_init':
> drivers/gpio/gpio-samsung.c:2974:1: warning: label 'err_ioremap4' defined but not used [-Wunused-label]
> drivers/gpio/gpio-samsung.c:2722:47: warning: unused variable 'gpio_base4' [-Wunused-variable]
>
> without adding more ifdef mess.
>
> I think this whole file would do well being coverted over to a platform
> driver and moving most of the tables out to SoC code and/or device trees,
> but since that changes init ordering it needs to be done with some care,
> i.e. not at this time.
>
> Signed-off-by: Olof Johansson<olof@lixom.net>

Looks ok to me :)

Acked-by: Kukjin Kim <kgene.kim@samsung.com>

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

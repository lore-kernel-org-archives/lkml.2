Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751845Ab2LSWXI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 17:23:08 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:33295 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352Ab2LSWW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 17:22:59 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] gpio: samsung: remove exynos_gpio_cfg
To: Joonyoung Shim <jy0922.shim@samsung.com>, linus.walleij@linaro.org
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kgene.kim@samsung.com, kyungmin.park@samsung.com
In-Reply-To: <1355481842-17952-1-git-send-email-jy0922.shim@samsung.com>
References: <1355481842-17952-1-git-send-email-jy0922.shim@samsung.com>
Date: Wed, 19 Dec 2012 22:22:55 +0000
Message-Id: <20121219222255.49E263E0AD6@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Dec 2012 19:44:01 +0900, Joonyoung Shim <jy0922.shim@samsung.com> wrote:
> The exynos_gpio_cfg can be substituted to samsung_gpio_cfgs[8].
> 
> Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>

Hi Joonyoung,

I need some help here. I don't understand what this patch is for or how
it works. The commit text above doesn't give me enough information to
evaluate the patch. What is the intent here? Why is samsung_gpio_cfgs[8]
more correct than exynos_gpio_cfg?

g.


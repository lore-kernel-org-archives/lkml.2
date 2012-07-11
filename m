Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933346Ab2GKV4O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 17:56:14 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:63521 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758253Ab2GKV4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 17:56:10 -0400
MIME-Version: 1.0
In-Reply-To: <201207112126.36412.rjw@sisk.pl>
References: <201207112121.11046.rjw@sisk.pl>
	<201207112126.36412.rjw@sisk.pl>
Date: Wed, 11 Jul 2012 23:56:09 +0200
Message-ID: <CACRpkdbLWTOAvqT==XoFuU2++Y_OvNBrGwWmATcPyK6EP90miw@mail.gmail.com>
Subject: Re: [PATCH 6/7] i2c-stu300: Use struct dev_pm_ops for power management
From: Linus Walleij <linus.walleij@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-i2c@vger.kernel.org, Sonic Zhang <sonic.zhang@analog.com>,
        Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Peter Korsgaard <jacmet@sunsite.dk>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Vitaly Wool <vitalywool@gmail.com>, Colin Cross <ccross@android.com>,
        Stephen Warren <swarren@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2012 at 9:26 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
>
> Make the ST-Ericsson U300 I2C controller driver define its PM
> callbacks through a struct dev_pm_ops object rather than by using
> legacy PM hooks in struct platform_driver.
>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Great, thanks!
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij

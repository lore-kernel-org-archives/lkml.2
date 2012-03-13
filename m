Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030325Ab2CMKN3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 06:13:29 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:39418 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030307Ab2CMKN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 06:13:27 -0400
MIME-Version: 1.0
In-Reply-To: <1331469965-28846-1-git-send-email-thomas.abraham@linaro.org>
References: <1331469965-28846-1-git-send-email-thomas.abraham@linaro.org>
Date: Tue, 13 Mar 2012 11:13:26 +0100
Message-ID: <CACRpkdYB4ambuDeMUX1kZn793xxfaaNjQ56EB4C8OAykMxoPJQ@mail.gmail.com>
Subject: Re: [PATCH 0/5] pinctrl: add new Samsung pinctrl driver and add
 Exynos4 support
From: Linus Walleij <linus.walleij@linaro.org>
To: Thomas Abraham <thomas.abraham@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, kgene.kim@samsung.com,
        patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 11, 2012 at 1:46 PM, Thomas Abraham
<thomas.abraham@linaro.org> wrote:

> This patch series adds new pinctrl driver for Samsung SoC's. The driver supports
> a gpiolib interface as well since Samsung SoC's have a combined pinmux/pinctrl
> and gpio controller.

Overall this all looks good to me Thomas!
I will provide detailed review if/when it is more ripe for merge.

Yours,
Linus Walleij

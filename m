Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048Ab2DRLlW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 07:41:22 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:65455 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200Ab2DRLlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 07:41:21 -0400
MIME-Version: 1.0
In-Reply-To: <1334646046-467-2-git-send-email-b29396@freescale.com>
References: <1334646046-467-1-git-send-email-b29396@freescale.com>
	<1334646046-467-2-git-send-email-b29396@freescale.com>
Date: Wed, 18 Apr 2012 13:41:21 +0200
Message-ID: <CACRpkdYhsOV-5FqXk3kesQaQtxE8it1QKq2jzcy3if4eQHYtUQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] pinctrl: show pin name for pingroups in sysfs
From: Linus Walleij <linus.walleij@linaro.org>
To: Dong Aisheng <b29396@freescale.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linus.walleij@stericsson.com, swarren@wwwdotorg.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 9:00 AM, Dong Aisheng <b29396@freescale.com> wrote:

> After change, when cat pingroups in sysfs, it becomes:
> root@freescale /sys/kernel/debug/pinctrl/20e0000.iomuxc$ cat pingroups
> registered pin groups:
> group: uart4grp-1
> pin 219 (MX6Q_PAD_KEY_ROW0)
> pin 218 (MX6Q_PAD_KEY_COL0)
>
> group: usdhc4grp-1
> pin 305 (MX6Q_PAD_SD4_CMD)
> pin 306 (MX6Q_PAD_SD4_CLK)
> pin 315 (MX6Q_PAD_SD4_DAT0)
> pin 316 (MX6Q_PAD_SD4_DAT1)
> pin 317 (MX6Q_PAD_SD4_DAT2)
> pin 318 (MX6Q_PAD_SD4_DAT3)
> pin 319 (MX6Q_PAD_SD4_DAT4)
> pin 320 (MX6Q_PAD_SD4_DAT5)
> pin 321 (MX6Q_PAD_SD4_DAT6)
> pin 322 (MX6Q_PAD_SD4_DAT7)

Applied with this bit copied into the commit message and Stepgen's ACK.

Thanks!
Linus Walleij

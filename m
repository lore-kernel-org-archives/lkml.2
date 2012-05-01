Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757057Ab2EAXNA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 19:13:00 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:36622 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755622Ab2EAXM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 19:12:58 -0400
MIME-Version: 1.0
In-Reply-To: <1335529578-14507-4-git-send-email-b29396@freescale.com>
References: <1335529578-14507-1-git-send-email-b29396@freescale.com>
	<1335529578-14507-4-git-send-email-b29396@freescale.com>
Date: Wed, 2 May 2012 01:12:58 +0200
Message-ID: <CACRpkdbE=fFhTr=MyD-2dgV=W07Kb-T+ax4dgdjZ8ONzoz3K7A@mail.gmail.com>
Subject: Re: [PATCH v4 4/4] mmc: sdhci-imx-esdhc: convert to use pinctrl subsystem
From: Linus Walleij <linus.walleij@linaro.org>
To: Dong Aisheng <b29396@freescale.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, linus.walleij@stericsson.com,
        swarren@wwwdotorg.org, s.hauer@pengutronix.de, shawn.guo@freescale.com,
        kernel@pengutronix.de, grant.likely@secretlab.ca,
        rob.herring@calxeda.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 2:26 PM, Dong Aisheng <b29396@freescale.com> wrote:

> From: Dong Aisheng <dong.aisheng@linaro.org>
>
> This driver is shared between many platforms. Currently only imx6q has
> pinctrl support, to avoid breaking other platforms that do not have pinctrl
> support to run this driver, enable pinctrl dummy state for them before
> they also convert to pinctrl subsystem.
>
> Acked-by: Stephen Warren <swarren@wwwdotorg.org>
> Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
> ---
> This patch depends on:
> pinctrl: add pinctrl_provide_dummies interface for platforms to use
> http://www.spinics.net/lists/arm-kernel/msg171538.html

I cannot apply this unless I get the i.MX maintainers ACK on it
(and I fear creating a lot of merge conflicts...)

If I cannot apply it there are two ways to proceed:
1. Wait for next merge window
2. Pull pinctrl into i.MX tree

Yours,
Linus Walleij

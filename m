Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112Ab2DXI4r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 04:56:47 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:48171 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756450Ab2DXI4o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 04:56:44 -0400
MIME-Version: 1.0
In-Reply-To: <1334933916-12971-3-git-send-email-b29396@freescale.com>
References: <1334933916-12971-1-git-send-email-b29396@freescale.com>
	<1334933916-12971-3-git-send-email-b29396@freescale.com>
Date: Tue, 24 Apr 2012 10:56:43 +0200
Message-ID: <CACRpkdbbdkhN-hVF6vP4j6bP-Nsdft5UjjpAVhcKn6KSpEbcuQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] ARM: imx6q: switch to use pinctrl driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Dong Aisheng <b29396@freescale.com>, Wolfram Sang <w.sang@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, linus.walleij@stericsson.com,
        devicetree-discuss@lists.ozlabs.org, rob.herring@calxeda.com,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de,
        Chris Ball <cjb@laptop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2012 at 4:58 PM, Dong Aisheng <b29396@freescale.com> wrote:

> From: Dong Aisheng <dong.aisheng@linaro.org>
>
> Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
>
> ---
> This is not a formal patch and is only used for test
> since before the pinctrl core handle dummy state is in,
> enable pinctrl in driver will break other platforms.
>
> ChangeLog v1->v2:
> * using updated binding
> ---
>  arch/arm/boot/dts/imx6q-arm2.dts   |    2 ++
>  arch/arm/boot/dts/imx6q.dtsi       |   17 +++++++++++++++++
>  arch/arm/mach-imx/Kconfig          |    2 ++
>  drivers/mmc/host/sdhci-esdhc-imx.c |   12 ++++++++++++
>  4 files changed, 33 insertions(+), 0 deletions(-)

Since this touches the MMC driver I'd like an ACK from the
maintainer, but no maintainer is set for this subdriver, still
it feels like Sascha and/or Wolfram should be involved.

Yours,
Linus Walleij

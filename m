Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640Ab2AAOPy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jan 2012 09:15:54 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56679 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353Ab2AAOPv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jan 2012 09:15:51 -0500
MIME-Version: 1.0
In-Reply-To: <1324541855-19911-2-git-send-email-haojian.zhuang@marvell.com>
References: <1324541855-19911-1-git-send-email-haojian.zhuang@marvell.com>
	<1324541855-19911-2-git-send-email-haojian.zhuang@marvell.com>
Date: Sun, 1 Jan 2012 15:15:51 +0100
Message-ID: <CACRpkdbvta3chYeMS=J94ehaOcEXp1OBnU74qSSCAO--PbehLg@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] pinctrl: enable pinmux for mmp series
From: Linus Walleij <linus.walleij@linaro.org>
To: Haojian Zhuang <haojian.zhuang@marvell.com>
Cc: swarren@nvidia.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, eric.y.miao@gmail.com,
        linux@arm.linux.org.uk, arnd@arndb.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 9:17 AM, Haojian Zhuang
<haojian.zhuang@marvell.com> wrote:

> Support PXA168/PXA910/MMP2 pinmux. Now only support function switch.

(...)

> +config PINCTRL_PXA3xx
> +       bool
> +       select PINMUX
> +

Good,

> +config PINMUX_MMP2
> +       bool "MMP2 pinmux driver"
> +       depends on ARCH_MMP
> +       select PINCTRL_PXA3xx
> +       select PINCONF
> +
> +config PINMUX_PXA168
> +       bool "PXA168 pinmux driver"
> +       depends on ARCH_MMP
> +       select PINCTRL_PXA3xx
> +       select PINCONF
> +
> +config PINMUX_PXA910
> +       bool "PXA910 pinmux driver"
> +       depends on ARCH_MMP
> +       select PINCTRL_PXA3xx
> +       select PINCONF
> +

Please rename these PINCTRL_* too.

Thanks,
Linus Walleij

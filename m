Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760069Ab2CPQQQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 12:16:16 -0400
Received: from gate.crashing.org ([63.228.1.57]:36925 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752733Ab2CPQQO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 12:16:14 -0400
Subject: Re: [PATCH v3 2/4] gpio: Move GE GPIO driver to reside within GPIO subsystem
Mime-Version: 1.0 (Apple Message framework v1257)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1331572380-1064-3-git-send-email-martyn.welch@ge.com>
Date: Fri, 16 Mar 2012 11:13:47 -0500
Cc: linuxppc-dev@lists.ozlabs.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Wim Van Sebroeck <wim@iguana.be>, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <EE34B23A-E2D0-4F49-B59A-F52B786E9020@kernel.crashing.org>
References: <1331572380-1064-1-git-send-email-martyn.welch@ge.com> <1331572380-1064-3-git-send-email-martyn.welch@ge.com>
To: Martyn Welch <martyn.welch@ge.com>
X-Mailer: Apple Mail (2.1257)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 12, 2012, at 12:12 PM, Martyn Welch wrote:

> The GE GPIO driver provides basic support (set direction, read/write state)
> for the GPIO provided on some GE single board computers. This patch moves
> the driver from the 86xx specific platform directrory to the GPIO subsystem
> so that it can be used on non-86xx boards.
> 
> Signed-off-by: Martyn Welch <martyn.welch@ge.com>
> ---
> 
> v3: Split out from patch moving PIC and GPIO driver. Moving to gpio subsystem
>    instead of sysdev.
> 
> arch/powerpc/configs/86xx/gef_ppc9a_defconfig      |    1 +
> arch/powerpc/configs/86xx/gef_sbc310_defconfig     |    1 +
> arch/powerpc/configs/86xx/gef_sbc610_defconfig     |    2 ++
> arch/powerpc/platforms/86xx/Makefile               |    3 +--
> drivers/gpio/Kconfig                               |   11 +++++++++++
> drivers/gpio/Makefile                              |    1 +
> .../86xx/gef_gpio.c => drivers/gpio/gpio-ge.c      |    2 +-
> 7 files changed, 18 insertions(+), 3 deletions(-)
> rename arch/powerpc/platforms/86xx/gef_gpio.c => drivers/gpio/gpio-ge.c (98%)

applied

- k
Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab2AAOHp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jan 2012 09:07:45 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51963 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461Ab2AAOHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jan 2012 09:07:43 -0500
MIME-Version: 1.0
In-Reply-To: <1324402840-32451-3-git-send-email-b29396@freescale.com>
References: <1324402840-32451-1-git-send-email-b29396@freescale.com>
	<1324402840-32451-3-git-send-email-b29396@freescale.com>
Date: Sun, 1 Jan 2012 15:07:43 +0100
Message-ID: <CACRpkdbLMW-SXnr6hbpwMqG=-a0wmYtU+YnyR8uLsndUp=UBgQ@mail.gmail.com>
Subject: Re: [RFC PATCH v3 2/5] pinctrl: add dt binding support for pinmux mappings
From: Linus Walleij <linus.walleij@linaro.org>
To: Dong Aisheng <b29396@freescale.com>
Cc: linux-kernel@vger.kernel.org, linus.walleij@stericsson.com,
        s.hauer@pengutronix.de, rob.herring@calxeda.com,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de,
        cjb@laptop.org, devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 20, 2011 at 6:40 PM, Dong Aisheng <b29396@freescale.com> wrote:

> From: Dong Aisheng <dong.aisheng@linaro.org>
>
> This patch provies a common API for driver to use to register pinmux
> mappings from dts file. It is needed for dt support.

Overall I feel lost in this discussion due to limited exposure to
device tree concepts. If I get Stephen Warrens and one of the
DT people's (Rob, Grant) ACK on this I'll be happy to merge it.

Until then, I guess it will need to be refined for the next kernel
cycle.

Yours,
Linus Walleij

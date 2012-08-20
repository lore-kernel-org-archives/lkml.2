Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529Ab2HTOLi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 10:11:38 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:52189 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755176Ab2HTOLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 10:11:36 -0400
MIME-Version: 1.0
In-Reply-To: <1344689809-6223-2-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1344689809-6223-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1344689809-6223-2-git-send-email-sebastian.hesselbarth@gmail.com>
Date: Mon, 20 Aug 2012 16:11:35 +0200
Message-ID: <CACRpkdZvjLx4+2CpgOemwWVfyFjFbRe-pzZbwAjExqHhQqBOjA@mail.gmail.com>
Subject: Re: [PATCH 01/11] pinctrl: mvebu: pinctrl driver core
From: Linus Walleij <linus.walleij@linaro.org>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Lior Amsalem <alior@marvell.com>, Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 11, 2012 at 2:56 PM, Sebastian Hesselbarth
<sebastian.hesselbarth@gmail.com> wrote:

> This patch adds a pinctrl driver core for Marvell SoCs plus DT
> binding documentation. This core driver will be used by SoC family
> specific drivers, i.e. Armada XP, Armada 370, Dove, Kirkwood, aso.
(...)
> +config PINCTRL_MVEBU
> +       bool "Marvell SoC pin controller drivers"
> +       depends on ARCH_MVEBU

So altering earlier statements I suspect this should be simply:

depends on PLAT_ORION

Yours,
Linus Walleij

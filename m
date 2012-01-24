Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904Ab2AXXNJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 18:13:09 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43472 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473Ab2AXXNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 18:13:07 -0500
MIME-Version: 1.0
In-Reply-To: <CAOesGMjuewhO2H+QFQtAX+xFb5hyNn8Q65Cuup4vaXWAFvX87w@mail.gmail.com>
References: <1327083746-31430-1-git-send-email-swarren@nvidia.com>
	<1327083746-31430-3-git-send-email-swarren@nvidia.com>
	<CACRpkdZ_hBviswq7pXoLozC8gjzvowCBrj9yjw1xJT79b5rtwQ@mail.gmail.com>
	<CAOesGMjuewhO2H+QFQtAX+xFb5hyNn8Q65Cuup4vaXWAFvX87w@mail.gmail.com>
Date: Wed, 25 Jan 2012 00:13:06 +0100
Message-ID: <CACRpkdayNsOFkOwLZNO_pJnNmM=NmSZhkJtAwkHxQvHovdF0uw@mail.gmail.com>
Subject: Re: [PATCH 3/4] ARM: tegra: Switch to new pinctrl driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Olof Johansson <olof@lixom.net>
Cc: Stephen Warren <swarren@nvidia.com>, Colin Cross <ccross@android.com>,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 24, 2012 at 11:44 PM, Olof Johansson <olof@lixom.net> wrote:

> Yup, I've just been waiting on things to settle,
> bindings/implementation wise. Will look at it over the next day or two
> and get back.

The only bindings you need to look into for this patch set should be
for the driver itself, the other muxmap bindings discussion I would
*very* much like to keep orthogonal to the review of this driver.

I'm pretty scared of how device tree bindings seem to suck in
every discussion like a black hole and then explode in a myriad
fragmented discussions like a supernova :-P

Yours,
Linus Walleij

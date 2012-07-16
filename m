Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185Ab2GPWf4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 18:35:56 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:32771 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753322Ab2GPWfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 18:35:54 -0400
MIME-Version: 1.0
In-Reply-To: <1342421510-10638-6-git-send-email-ldewangan@nvidia.com>
References: <1342421510-10638-1-git-send-email-ldewangan@nvidia.com>
	<1342421510-10638-6-git-send-email-ldewangan@nvidia.com>
Date: Tue, 17 Jul 2012 00:35:53 +0200
Message-ID: <CACRpkdaPjGK+yFx5cSmqGkbUjPchpOhc=zQQL8bKWnrripnT1Q@mail.gmail.com>
Subject: Re: [PATCH V2 5/6] ARM: tegra: defconfig: enable tps6586x gpio
From: Linus Walleij <linus.walleij@linaro.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: grant.likely@secretlab.ca, linus.walleij@stericsson.com,
        sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        swarren@nvidia.com, broonie@opensource.wolfsonmicro.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16, 2012 at 8:51 AM, Laxman Dewangan <ldewangan@nvidia.com> wrote:

> Enable GPIO_TPS6586X as the gpio functionality of
> this device moved as platform driver.
>
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij

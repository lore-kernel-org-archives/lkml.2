Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752253Ab2AXWhc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 17:37:32 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49534 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051Ab2AXWha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 17:37:30 -0500
MIME-Version: 1.0
In-Reply-To: <1327083746-31430-4-git-send-email-swarren@nvidia.com>
References: <1327083746-31430-1-git-send-email-swarren@nvidia.com>
	<1327083746-31430-4-git-send-email-swarren@nvidia.com>
Date: Tue, 24 Jan 2012 23:37:30 +0100
Message-ID: <CACRpkdbzBLqgKSNrBBkkQi+xRz-v=3oAu=n8YFrWhr5syrDFVg@mail.gmail.com>
Subject: Re: [PATCH 4/4] ARM: tegra: Remove pre-pinctrl pinmux driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Olof Johansson <olof@lixom.net>, Colin Cross <ccross@android.com>,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 20, 2012 at 7:22 PM, Stephen Warren <swarren@nvidia.com> wrote:

> The pinctrl driver is now active and used by all boards. Remove the
> old pinmux driver.
>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij

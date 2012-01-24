Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219Ab2AXWeY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 17:34:24 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:45116 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752126Ab2AXWeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 17:34:23 -0500
MIME-Version: 1.0
In-Reply-To: <1327083746-31430-2-git-send-email-swarren@nvidia.com>
References: <1327083746-31430-1-git-send-email-swarren@nvidia.com>
	<1327083746-31430-2-git-send-email-swarren@nvidia.com>
Date: Tue, 24 Jan 2012 23:34:22 +0100
Message-ID: <CACRpkdZ_BzwQLZ74JS2WGePUO5kGCrAFMBQjy3ZeeAkbrwHNXg@mail.gmail.com>
Subject: Re: [PATCH 2/4] ARM: tegra: Select PINCTRL Kconfig variables
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

> This causes the Tegra pinctrl driver to be built whenever core Tegra
> support is enabled.
>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Thanks!
Linus Walleij

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748Ab2BAUL5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 15:11:57 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37601 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348Ab2BAUL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 15:11:56 -0500
MIME-Version: 1.0
In-Reply-To: <20120201082011.GK7399@quad.lixom.net>
References: <1327083746-31430-1-git-send-email-swarren@nvidia.com>
	<1327083746-31430-3-git-send-email-swarren@nvidia.com>
	<CACRpkdZ_hBviswq7pXoLozC8gjzvowCBrj9yjw1xJT79b5rtwQ@mail.gmail.com>
	<20120201082011.GK7399@quad.lixom.net>
Date: Wed, 1 Feb 2012 21:11:55 +0100
Message-ID: <CACRpkdZ76PamNGOuhuqNvMx9k6hRR2MD2L7sJnv7nU_A45Yypg@mail.gmail.com>
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

On Wed, Feb 1, 2012 at 9:20 AM, Olof Johansson <olof@lixom.net> wrote:

> This series is:
> Acked-by: Olof Johansson <olof@lixom.net>

OK that's great!

> can you land this series in a stable branch in
> your tree that you promise not to rebase between now and upstream
> submission?

I thinkso, I rebased to some fixes from -rc2 today but no need to
do that again, there is one bug fix which may end up in both
mainline and my tree but whatever, git will cope.

However I am waiting for Stephen to do some fixes and arrive
at a final version first.

Linus Walleij

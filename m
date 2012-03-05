Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756808Ab2CEKeO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 05:34:14 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54711 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756418Ab2CEKeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 05:34:11 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus.walleij@linaro.org designates 10.50.203.98 as permitted sender) smtp.mail=linus.walleij@linaro.org
MIME-Version: 1.0
In-Reply-To: <1330718750-15217-8-git-send-email-swarren@nvidia.com>
References: <1330718750-15217-1-git-send-email-swarren@nvidia.com>
	<1330718750-15217-8-git-send-email-swarren@nvidia.com>
Date: Mon, 5 Mar 2012 11:34:11 +0100
Message-ID: <CACRpkdZY0d619UXcnXcq5_xJQdW9Y9M5gTPeVno2vDgSSucvqA@mail.gmail.com>
Subject: Re: [PATCH V3 7/7] pinctrl: fix case of Tegra30's foo_groups[] arrays
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, B29396@freescale.com,
        s.hauer@pengutronix.de, dongas86@gmail.com, shawn.guo@linaro.org,
        thomas.abraham@linaro.org, tony@atomide.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 2, 2012 at 9:05 PM, Stephen Warren <swarren@nvidia.com> wrote:

> Tegra's pin groups all have lower-case names. Fix the foo_groups[] arrays
> in the driver to be lower-case to match.
>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

Applied this to my tegra-diet branch (the one with just the driver and
not board file changes).

Can I squash it with the patch that introduce the capitalized names
so as to avoid pointless churn?

Yours,
Linus Walleij

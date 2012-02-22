Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654Ab2BVGXG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 01:23:06 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61296 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497Ab2BVGXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 01:23:05 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus.walleij@linaro.org designates 10.50.202.97 as permitted sender) smtp.mail=linus.walleij@linaro.org
MIME-Version: 1.0
In-Reply-To: <1329720360-23227-13-git-send-email-swarren@nvidia.com>
References: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
	<1329720360-23227-13-git-send-email-swarren@nvidia.com>
Date: Wed, 22 Feb 2012 07:23:04 +0100
Message-ID: <CACRpkdbz4QxV7eNn-pi5jOy204t7iHmTLw4WTgyFv+d04etAEQ@mail.gmail.com>
Subject: Re: [PATCH 12/20] pinctrl: Use dev_*() instead of pr_*(), add some
 msgs, minor cleanups
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

On Mon, Feb 20, 2012 at 7:45 AM, Stephen Warren <swarren@nvidia.com> wrote:

> e.g. dev_err instead of pr_err prints messages in a slightly more
> standardized format.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Fine with me but I couldn't apply it due to too many conflicts due to
the unapplied patch for handling NULL regulators that we haven't
ironed out yet, so will need some rebasing...

Thanks,
Linus Walleij

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041Ab2BTVD0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 16:03:26 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47456 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329Ab2BTVDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 16:03:25 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus.walleij@linaro.org designates 10.43.51.135 as permitted sender) smtp.mail=linus.walleij@linaro.org
MIME-Version: 1.0
In-Reply-To: <1329720360-23227-3-git-send-email-swarren@nvidia.com>
References: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
	<1329720360-23227-3-git-send-email-swarren@nvidia.com>
Date: Mon, 20 Feb 2012 22:03:25 +0100
Message-ID: <CACRpkdb-pymoDaV9HwjoHbmdaBM0P3Ysz4dqdBPPNZkunEww6w@mail.gmail.com>
Subject: Re: [PATCH 02/20] pinctrl: use list_add_tail instead of list_add
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

> This mostly makes debugfs files print things in the order that they
> were added or acquired, which just feels a little more consistent.
>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

OK applied.

Thanks,
Linus Walleij

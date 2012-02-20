Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096Ab2BTVUO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 16:20:14 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:45247 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480Ab2BTVUM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 16:20:12 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus.walleij@linaro.org designates 10.50.202.97 as permitted sender) smtp.mail=linus.walleij@linaro.org
MIME-Version: 1.0
In-Reply-To: <1329720360-23227-8-git-send-email-swarren@nvidia.com>
References: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
	<1329720360-23227-8-git-send-email-swarren@nvidia.com>
Date: Mon, 20 Feb 2012 22:20:11 +0100
Message-ID: <CACRpkdaQL7npk8p8=AFzgRKDWNL1CBc=Gct2ihb9fBcMgYTQBQ@mail.gmail.com>
Subject: Re: [PATCH 07/20] pinctrl: core.c/h cleanups
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, B29396@freescale.com,
        s.hauer@pengutronix.de, dongas86@gmail.com, shawn.guo@linaro.org,
        thomas.abraham@linaro.org, tony@atomide.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 20, 2012 at 7:45 AM, Stephen Warren <swarren@nvidia.com> wrote:

> * Make all functions internal to core.c static. Remove any of these from
>  core.h.
> * Add any missing EXPORT_SYMBOL_GPL().
>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

OK applied.

Thanks,
Linus Walleij

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914Ab2BTVS1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 16:18:27 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62159 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329Ab2BTVS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 16:18:26 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus.walleij@linaro.org designates 10.43.51.135 as permitted sender) smtp.mail=linus.walleij@linaro.org
MIME-Version: 1.0
In-Reply-To: <1329720360-23227-7-git-send-email-swarren@nvidia.com>
References: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
	<1329720360-23227-7-git-send-email-swarren@nvidia.com>
Date: Mon, 20 Feb 2012 22:18:26 +0100
Message-ID: <CACRpkdbT-Yzi1ZrMxD7j+kjH9E9_c1BaeaNsbL2oZTv0DYJ=fg@mail.gmail.com>
Subject: Re: [PATCH 06/20] pinctrl: Re-order pinconf.[ch] to match each-other
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

> Modify the two files so that the order of function prototypes in the
> header matches the order of implementations in the .c file.
>
> Don't prototype a couple of internal functions.
>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

OK applied.

Thanks,
Linus Walleij

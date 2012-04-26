Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759021Ab2DZVgy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 17:36:54 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:50954 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141Ab2DZVgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 17:36:53 -0400
MIME-Version: 1.0
In-Reply-To: <1335353894-22096-1-git-send-email-b29396@freescale.com>
References: <1335353894-22096-1-git-send-email-b29396@freescale.com>
Date: Thu, 26 Apr 2012 23:36:52 +0200
Message-ID: <CACRpkdadLsqpb=X+BmomyRywf=SrgGpbW2B=Myo3zTn_xMHJ2g@mail.gmail.com>
Subject: Re: [PATCH 1/2] pinctrl: support gpio request deferred probing
From: Linus Walleij <linus.walleij@linaro.org>
To: Dong Aisheng <b29396@freescale.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linus.walleij@stericsson.com, swarren@wwwdotorg.org,
        s.hauer@pengutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2012 at 1:38 PM, Dong Aisheng <b29396@freescale.com> wrote:

> From: Dong Aisheng <dong.aisheng@linaro.org>
>
> As pinctrl handles, it may be possible the pinctrl gpio ranges
> are still not got registered when user call pinctrl_gpio_request.
> Thus, add defer support for it too.
>
> Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>

Since nobody is saying anything and it looks reasonable,
I just applied this.

Thanks!
Linus Walleij

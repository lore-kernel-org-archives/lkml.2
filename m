Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759204Ab2DZVdF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 17:33:05 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:50696 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758738Ab2DZVdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 17:33:03 -0400
MIME-Version: 1.0
In-Reply-To: <1335428150-12629-1-git-send-email-b29396@freescale.com>
References: <1335428150-12629-1-git-send-email-b29396@freescale.com>
Date: Thu, 26 Apr 2012 23:33:02 +0200
Message-ID: <CACRpkdZx2zZund1gtiEqfKMP83xBfU=cj+HK_H1zSoEEZdPbow@mail.gmail.com>
Subject: Re: [PATCH v4 1/1] pinctrl: add pinctrl_provide_dummies interface for
 platforms to use
From: Linus Walleij <linus.walleij@linaro.org>
To: Dong Aisheng <b29396@freescale.com>
Cc: linux-kernel@vger.kernel.org, s.hauer@pengutronix.de,
        linus.walleij@stericsson.com, linux-arm-kernel@lists.infradead.org,
        swarren@wwwdotorg.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2012 at 10:15 AM, Dong Aisheng <b29396@freescale.com> wrote:

> From: Dong Aisheng <dong.aisheng@linaro.org>
>
> Add a interface pinctrl_provide_dummies for platform to indicate
> whether it needs use pinctrl dummy state.
>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Stephen Warren <swarren@nvidia.com>
> Cc: Sascha Hauer <s.hauer@pengutronix.de>
> Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>

Great!
Applied with Stephen's ACK.

Yours,
Linus Walleij

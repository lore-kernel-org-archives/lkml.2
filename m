Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073Ab2JVNUY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 09:20:24 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:52839 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753279Ab2JVNUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 09:20:22 -0400
MIME-Version: 1.0
In-Reply-To: <1350909125-20189-2-git-send-email-ulf.hansson@stericsson.com>
References: <1350909125-20189-1-git-send-email-ulf.hansson@stericsson.com>
	<1350909125-20189-2-git-send-email-ulf.hansson@stericsson.com>
Date: Mon, 22 Oct 2012 15:20:21 +0200
Message-ID: <CACRpkdZMujAko6sBTD=dv_4uOdfE33WYv6fFgqY5xsKJw=Eu7Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] ASoC: Ux500: Control apb clock
From: Linus Walleij <linus.walleij@linaro.org>
To: Ulf Hansson <ulf.hansson@stericsson.com>
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Lee Jones <lee.jones@linaro.org>,
        Ola Lilja <ola.o.lilja@stericsson.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 2:32 PM, Ulf Hansson <ulf.hansson@stericsson.com> wrote:

> From: Ulf Hansson <ulf.hansson@linaro.org>
>
> When switching to common clock driver for ux500 this clock needs to
> be handled as well. Before this clock was internally managed by the
> clock driver itself.
>
> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

Looks correct, Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij

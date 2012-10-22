Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918Ab2JVNTc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 09:19:32 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:41868 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334Ab2JVNTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 09:19:31 -0400
MIME-Version: 1.0
In-Reply-To: <1350909125-20189-1-git-send-email-ulf.hansson@stericsson.com>
References: <1350909125-20189-1-git-send-email-ulf.hansson@stericsson.com>
Date: Mon, 22 Oct 2012 15:19:30 +0200
Message-ID: <CACRpkdasuxBaQ28cgV52isgGK7Lhq3dtYAp1ogyD68EhpRmSdw@mail.gmail.com>
Subject: Re: [PATCH 1/2] ASoC: Ux500: Fixup use of clocks
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
> Make sure clocks are being prepared and unprepared as well
> as enabled and disabled.
>
> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Thanks,
Linus Walleij

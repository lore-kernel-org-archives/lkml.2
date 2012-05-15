Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757418Ab2EOHpW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 03:45:22 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:50316 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757237Ab2EOHpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 03:45:20 -0400
MIME-Version: 1.0
In-Reply-To: <1336993600-30065-2-git-send-email-b29396@freescale.com>
References: <1336993600-30065-1-git-send-email-b29396@freescale.com>
	<1336993600-30065-2-git-send-email-b29396@freescale.com>
Date: Tue, 15 May 2012 09:45:19 +0200
Message-ID: <CACRpkdYmJo8FnARu6GvThe7ofDCUdc9Bavjw3rzrDsXtAbZKSw@mail.gmail.com>
Subject: Re: [PATCH 2/5] pinctrl: make pinmux disable function optional
From: Linus Walleij <linus.walleij@linaro.org>
To: Dong Aisheng <b29396@freescale.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linus.walleij@stericsson.com, swarren@wwwdotorg.org,
        haojian.zhuang@marvell.com, shawn.guo@freescale.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2012 at 1:06 PM, Dong Aisheng <b29396@freescale.com> wrote:

> From: Dong Aisheng <dong.aisheng@linaro.org>
>
> Some SoCs may not have pinmux disable function in HW.
>
> Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>

Good idea.

Applied with Stepgen's ACK.

Thanks,
Linus Walleij

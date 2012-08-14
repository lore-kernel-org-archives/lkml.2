Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391Ab2HNI4B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 04:56:01 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:63699 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754668Ab2HNI4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 04:56:00 -0400
MIME-Version: 1.0
In-Reply-To: <1344527268-5964-7-git-send-email-lee.jones@linaro.org>
References: <1344527268-5964-1-git-send-email-lee.jones@linaro.org>
	<1344527268-5964-7-git-send-email-lee.jones@linaro.org>
Date: Tue, 14 Aug 2012 10:55:59 +0200
Message-ID: <CACRpkdb09UnPj6xV-rNxoeUS2yPLurA+n6zygWEA3_7OQfb0nA@mail.gmail.com>
Subject: Re: [PATCH 06/22] ASoC: Ux500: Enable ux500 MSP driver for Device Tree
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, broonie@opensource.wolfsonmicro.com,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 9, 2012 at 5:47 PM, Lee Jones <lee.jones@linaro.org> wrote:

> Register both parts of the MSP driver from Device Tree so that they
> are probed when Device Tree is enabled. Also, as there is platform
> data involved, we ensure that there is allocated memory to place the
> configuration into and that the correct information is extracted from
> the DT binary.
>
> CC: alsa-devel@alsa-project.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Looks like it's doing what's intended...
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij

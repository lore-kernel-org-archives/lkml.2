Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363Ab2HNIw1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 04:52:27 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:64993 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755162Ab2HNIwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 04:52:24 -0400
MIME-Version: 1.0
In-Reply-To: <1344527268-5964-6-git-send-email-lee.jones@linaro.org>
References: <1344527268-5964-1-git-send-email-lee.jones@linaro.org>
	<1344527268-5964-6-git-send-email-lee.jones@linaro.org>
Date: Tue, 14 Aug 2012 10:52:23 +0200
Message-ID: <CACRpkdZ+zgEf48qpCRg_fz9=_oSGohuSsFLQoC3BzTgSDdNnZA@mail.gmail.com>
Subject: Re: [PATCH 05/22] ASoC: Ux500: Enable MOP500 driver for Device Tree
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, linus.walleij@stericsson.com,
        arnd@arndb.de, broonie@opensource.wolfsonmicro.com,
        STEricsson_nomadik_linux@list.st.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 9, 2012 at 5:47 PM, Lee Jones <lee.jones@linaro.org> wrote:

> Here we ensure that the MOP500 audio driver will be probed during a
> Device Tree boot. We also parse the sound node to link together the
> codec, dma and the CPU-side Digital Audio Interface.
>
> CC: alsa-devel@alsa-project.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

But only if Mark agrees with the overall approach.

Yours,
Linus Walleij

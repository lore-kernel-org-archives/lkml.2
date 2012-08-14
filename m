Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570Ab2HNLIZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 07:08:25 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:42369 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750Ab2HNLIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 07:08:24 -0400
MIME-Version: 1.0
In-Reply-To: <1344527268-5964-8-git-send-email-lee.jones@linaro.org>
References: <1344527268-5964-1-git-send-email-lee.jones@linaro.org>
	<1344527268-5964-8-git-send-email-lee.jones@linaro.org>
Date: Tue, 14 Aug 2012 13:08:23 +0200
Message-ID: <CACRpkdbc6bGC4Yp7Bcdfev=Uc=1h4L1v+Lj9RbmJV3F+knQOZQ@mail.gmail.com>
Subject: Re: [PATCH 07/22] ASoC: Ux500: Initialise PCM from MSP probe rather
 than as a device
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>, Ola LILJA2 <ola.o.lilja@stericsson.com>,
        Ola Lilja <olalilja@yahoo.se>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, linus.walleij@stericsson.com,
        arnd@arndb.de, broonie@opensource.wolfsonmicro.com,
        STEricsson_nomadik_linux@list.st.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 9, 2012 at 5:47 PM, Lee Jones <lee.jones@linaro.org> wrote:

> The PCM is a pseudo-device. It doesn't have any of it's own registers
> or hardware. It rather acts as a layer of abstraction for DMA
> transfers. Hence, instead of classifying it as a device in its own
> right, we call the initialisation from the MSP driver.
>
> CC: alsa-devel@alsa-project.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

I'd prefer to have Ola LILJA review this patch, but it looks alright to me.
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427Ab2GIUgT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 16:36:19 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:51118 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753142Ab2GIUgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 16:36:18 -0400
MIME-Version: 1.0
In-Reply-To: <4FFB2809.3020005@linaro.org>
References: <1341493572-29735-1-git-send-email-lee.jones@linaro.org>
	<1341493572-29735-9-git-send-email-lee.jones@linaro.org>
	<4FF6A2DF.5030407@linaro.org>
	<CACRpkdZJAiBvatPGpKZP4mgUb-M-pPY34LVaj7ANkRaX9C4fJQ@mail.gmail.com>
	<4FFB2809.3020005@linaro.org>
Date: Mon, 9 Jul 2012 22:36:17 +0200
Message-ID: <CACRpkdaw1wb3yR8FunOZJ8QPMxwS5V3NoVQj_mBUyKE1wWcPWA@mail.gmail.com>
Subject: Re: [PATCH 8/9] ARM: ux500: Clean-up temporary Device Tree enablement helpers
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linus.walleij@stericsson.com, STEricsson_nomadik_linux@list.st.com,
        arnd@arndb.de, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 9, 2012 at 8:50 PM, Lee Jones <lee.jones@linaro.org> wrote:

> Better?

Yep!

> From 9ef8a52c00dedbd63b6eecc086f8bd688d2cb66a Mon Sep 17 00:00:00 2001
> From: Lee Jones <lee.jones@linaro.org>
> Date: Wed, 27 Jun 2012 08:42:08 +0100
> Subject: [PATCH 1/1] ARM: ux500: Clean-up temporary Device Tree enablement
>  helpers
>
> Here we remove some of the extra overhead we introduced to make
> DT:ing the Snowball platform easier.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij

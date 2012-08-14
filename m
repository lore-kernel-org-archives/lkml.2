Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181Ab2HNITq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 04:19:46 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:65101 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753815Ab2HNITo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 04:19:44 -0400
MIME-Version: 1.0
In-Reply-To: <1344527635-6163-4-git-send-email-lee.jones@linaro.org>
References: <1344527635-6163-1-git-send-email-lee.jones@linaro.org>
	<1344527635-6163-4-git-send-email-lee.jones@linaro.org>
Date: Tue, 14 Aug 2012 10:19:43 +0200
Message-ID: <CACRpkdYeo6jnVshj5n9kkBtj3ztxNUr-su6A9-ChQUqJaayhTg@mail.gmail.com>
Subject: Re: [PATCH 3/8] ARM: ux500: Identify the PRCMU as an interrupt controller
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, broonie@opensource.wolfsonmicro.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 9, 2012 at 5:53 PM, Lee Jones <lee.jones@linaro.org> wrote:

> We're just about to provide the DB8500-PRCMU with its own IRQ domain,
> so that its subordinate drivers can use it as an interrupt controller.
> It's obligatory for all IRQ controllers to reference themselves as
> such from its own node in Device Tree. This patch does just that.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij

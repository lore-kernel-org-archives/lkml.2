Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756721Ab2HTOeO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 10:34:14 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:41785 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756328Ab2HTOeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 10:34:12 -0400
MIME-Version: 1.0
In-Reply-To: <1344527268-5964-13-git-send-email-lee.jones@linaro.org>
References: <1344527268-5964-1-git-send-email-lee.jones@linaro.org>
	<1344527268-5964-13-git-send-email-lee.jones@linaro.org>
Date: Mon, 20 Aug 2012 16:34:11 +0200
Message-ID: <CACRpkdZU3NKmrM+MboJrk7nsmENc2B=acfsRobU0F-Zk1kGZcg@mail.gmail.com>
Subject: Re: [PATCH 12/22] ARM: ux500: Add AB8500 CODEC node to DB8500 Device Tree
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, broonie@opensource.wolfsonmicro.com,
        Ola LILJA2 <ola.o.lilja@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 9, 2012 at 5:47 PM, Lee Jones <lee.jones@linaro.org> wrote:

> Ensure correct probing and pass though important configuration
> options to the AB8500 CODEC driver when DT is enabled
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

FWIW:
Acked-by: Linus Walleij <linus.walleij@linaro.org>

But I think Ola and Marks ACKS are more important on this one.

Yours,
Linus Walleij

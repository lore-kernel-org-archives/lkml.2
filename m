Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757237Ab1F1LB3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 07:01:29 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36526 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755805Ab1F1LAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 07:00:14 -0400
MIME-Version: 1.0
In-Reply-To: <1308925806.2628.3.camel@phoenix>
References: <1308925806.2628.3.camel@phoenix>
Date: Tue, 28 Jun 2011 13:00:13 +0200
X-Google-Sender-Auth: MXH-Mejb1rX8xQi1MLquLkYe0yc
Message-ID: <BANLkTi=PgJ8u0pgOoDTaswJStBvsU2Ur8Q@mail.gmail.com>
Subject: Re: [PATCH] gpio: ab8500: fix MODULE_ALIAS for ab8500
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, BIBEK BASU <bibek.basu@stericsson.com>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/6/24 Axel Lin <axel.lin@gmail.com>:

> Since 43cc71eed1250755986da4c0f9898f9a635cb3bf (platform: prefix MODALIAS
> with "platform:"), the platform modalias is prefixed with "platform:".
>
> This patch changes the MODULE_ALIAS to "platform:ab8500-gpio".
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Thanks,
Linus Walleij

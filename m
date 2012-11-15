Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756826Ab2KOR2R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 12:28:17 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:58868 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271Ab2KOR2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 12:28:16 -0500
MIME-Version: 1.0
In-Reply-To: <1352968401-6092-1-git-send-email-lee.jones@linaro.org>
References: <1352968401-6092-1-git-send-email-lee.jones@linaro.org>
Date: Thu, 15 Nov 2012 18:28:14 +0100
Message-ID: <CACRpkda_AU+3kfjXQ4nA8JCoxdPmOVDdRhqSsQ3tUP5mS0jNMg@mail.gmail.com>
Subject: Re: [PATCH 1/1] ARM: ux500: Describe UART platform registering issues
 more accurately
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2012 at 9:33 AM, Lee Jones <lee.jones@linaro.org> wrote:

> UARTs no longer require call-back information, since the reset
> call-back was removed in 43b5f0d69291374f602ad8e1817f329573a59010.
> The only AUXDATA dependencies remaining for UARTs are DMA settings.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij

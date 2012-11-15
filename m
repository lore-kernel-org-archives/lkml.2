Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993379Ab2KOLaL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 06:30:11 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:51214 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993197Ab2KOLaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 06:30:09 -0500
MIME-Version: 1.0
In-Reply-To: <1352896551-17948-1-git-send-email-lee.jones@linaro.org>
References: <1352896551-17948-1-git-send-email-lee.jones@linaro.org>
Date: Thu, 15 Nov 2012 12:30:08 +0100
Message-ID: <CACRpkdZ+V1aiQ-c62v9jdv93wMGu9hrSnXj_a9jx3uOTbot44A@mail.gmail.com>
Subject: Re: [PATCH] mmc: Standardise capability type
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        Chris Ball <cjb@laptop.org>, linux-mmc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2012 at 1:35 PM, Lee Jones <lee.jones@linaro.org> wrote:

> There are discrepancies with regards to how MMC capabilities
> are carried throughout the subsystem. Let's standardise them
> to elevate any confusion.
>
> Cc: Chris Ball <cjb@laptop.org>
> Cc: linux-mmc@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Looks good to me, and these are obviously
u32 bitfields by design, so:
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij

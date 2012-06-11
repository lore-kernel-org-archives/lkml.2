Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323Ab2FKVnh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 17:43:37 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:50229 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840Ab2FKVng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 17:43:36 -0400
MIME-Version: 1.0
In-Reply-To: <1339428307-3850-15-git-send-email-lee.jones@linaro.org>
References: <1339428307-3850-1-git-send-email-lee.jones@linaro.org>
	<1339428307-3850-15-git-send-email-lee.jones@linaro.org>
Date: Mon, 11 Jun 2012 23:43:35 +0200
Message-ID: <CACRpkdbJdA8rgcXX4Xc3sMrx==5jd-Scu1Xy0UKz0ot3_bbNzw@mail.gmail.com>
Subject: Re: [PATCH 14/14] ARM: ux500: Move rtc-pl031 registration to Device
 Tree when enabled
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, arnd@arndb.de, grant.likely@secretlab.ca
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2012 at 5:25 PM, Lee Jones <lee.jones@linaro.org> wrote:

> During a Device Tree boot, all probing will now be completed on parse
> of the Device Tree binary. In the same patch we remove platform
> registration of the Real Time Clock.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Oh this is a bug fix really, well it's in the device tree so nevermind.
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij

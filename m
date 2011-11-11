Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757970Ab1KKPsp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 10:48:45 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52815 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756731Ab1KKPsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 10:48:43 -0500
MIME-Version: 1.0
In-Reply-To: <1321004878-17534-1-git-send-email-chanho61.park@samsung.com>
References: <1321004878-17534-1-git-send-email-chanho61.park@samsung.com>
Date: Fri, 11 Nov 2011 16:48:42 +0100
Message-ID: <CACRpkda3dE_g9q1Q_rhh8WXxkktYz-qL4dXBK0p8h2W_cBtP1Q@mail.gmail.com>
Subject: Re: [PATCHv3] pinctrl: add a pin_base for sparse gpio-ranges
From: Linus Walleij <linus.walleij@linaro.org>
To: Chanho Park <chanho61.park@samsung.com>
Cc: swarren@nvidia.com, Baohua.Song@csr.com, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 11, 2011 at 10:47 AM, Chanho Park <chanho61.park@samsung.com> wrote:

> This patch enables mapping a base offset of gpio ranges with
> a pin offset even if does'nt matched. A base of pinctrl_gpio_range
> means a base offset of gpio. However, we cannot convert gpio to pin
> number for sparse gpio ranges just only using a gpio base offset.
> We can convert a gpio to real pin number(even if not matched) using
> a new pin_base which means a base pin offset of requested gpio range.
> Now, the pin control subsystem passes the pin base offset to the
> pinmux driver.

Thanks, patch applied, however review my discussion with Stephen
about the usefulness of the GPIO-specific instructions altogether...

Yours,
Linus Walleij

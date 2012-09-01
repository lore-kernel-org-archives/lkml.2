Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464Ab2IAKwn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 06:52:43 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:42998 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552Ab2IAKwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 06:52:41 -0400
MIME-Version: 1.0
In-Reply-To: <1346479882.3272.1.camel@phoenix>
References: <1346479882.3272.1.camel@phoenix>
Date: Sat, 1 Sep 2012 12:52:40 +0200
Message-ID: <CACRpkdbY27VwiT_LFUT_kn6Q_eprZrs05=BL0hwRb9PnC499Vg@mail.gmail.com>
Subject: Re: [PATCH] gpio: rdc321x: Prevent removal of modules exporting
 active GPIOs
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: Florian Fainelli <florian@openwrt.org>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 1, 2012 at 8:11 AM, Axel Lin <axel.lin@gmail.com> wrote:

> This driver can be built as a module, set the missing owner field of
> struct gpio_chip to prevent removal of modules exporting active GPIOs.
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Applied.

Thanks,
Linus Walleij

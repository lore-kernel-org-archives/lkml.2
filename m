Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902Ab2ILVVz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 17:21:55 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:51182 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753643Ab2ILVVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 17:21:54 -0400
MIME-Version: 1.0
In-Reply-To: <1347016499-29354-20-git-send-email-lee.jones@linaro.org>
References: <1347016499-29354-1-git-send-email-lee.jones@linaro.org>
	<1347016499-29354-20-git-send-email-lee.jones@linaro.org>
Date: Wed, 12 Sep 2012 23:21:52 +0200
Message-ID: <CACRpkdYVP_rseFOzxUS+pDnG3mfpNm4nExG7DH7sawZVVjUcig@mail.gmail.com>
Subject: Re: [PATCH 19/19] gpio: Enable the tc3298x GPIO expander driver for
 Device Tree
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 7, 2012 at 1:14 PM, Lee Jones <lee.jones@linaro.org> wrote:

> Here we provide a means to probe and extract vital information
> from Device Tree when booting with it enabled. Without this
> patch sub-devices wouldn't be able to reference the tc3589x-gpio
> expander from Device Tree.
>
> CC: Grant Likely <grant.likely@secretlab.ca>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Applied as well.

Yours,
Linus Walleij

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab1H2Mn4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 08:43:56 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53915 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415Ab1H2Mnu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 08:43:50 -0400
MIME-Version: 1.0
In-Reply-To: <1312913020-7508-1-git-send-email-linus.walleij@stericsson.com>
References: <1312913020-7508-1-git-send-email-linus.walleij@stericsson.com>
Date: Mon, 29 Aug 2011 14:43:48 +0200
Message-ID: <CACRpkdZngg7mazP2XqdvyPXBRZs519a_R12Vss5K3oQhtMhv1w@mail.gmail.com>
Subject: Re: [PATCH 1/3] gpio/nomadik: remove pull-pinconfig and add SPI2
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Lee Jones <lee.jones@linaro.org>,
        Fredrik Svensson <fredrik.xk.svensson@stericsson.com>,
        Daniel Willerud <daniel.willerud@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 9, 2011 at 8:03 PM, Linus Walleij
<linus.walleij@stericsson.com> wrote:

> From: Fredrik Svensson <fredrik.xk.svensson@stericsson.com>
>
> Remove PIN_CFG_PULL in pincfg.h for plat-nomadik, PIN_CFG_INPUT
> already takes care of this. Added support for SPI2.
>
> Signed-off-by: Fredrik Svensson <fredrik.xk.svensson@stericsson.com>
> Signed-off-by: Daniel Willerud <daniel.willerud@stericsson.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  arch/arm/mach-ux500/pins-db8500.h           |  142 ++++++++++++++-------------
>  arch/arm/plat-nomadik/include/plat/pincfg.h |    5 -
>  2 files changed, 73 insertions(+), 74 deletions(-)

Since this one is only touching ux500 I'm picking it to the ux500-core
tree now, with new subject "mach-ux500: remove pull-pinconfig and add SPI2.

Makes for less conflicts anyway.

Still would like 2/3 and 3/3 to go into the gpio tree, knock knock :-)

Yours,
Linus Walleij

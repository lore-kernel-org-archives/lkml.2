Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223Ab2HaXFI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 19:05:08 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:62188 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755091Ab2HaXFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 19:05:07 -0400
MIME-Version: 1.0
In-Reply-To: <1346204214.13176.2.camel@phoenix>
References: <1346204124.13176.0.camel@phoenix>
	<1346204214.13176.2.camel@phoenix>
Date: Sat, 1 Sep 2012 01:05:06 +0200
Message-ID: <CACRpkdZbxG8+4k5WS0i+--YU=wf10wwNorbTyt0uFcxw+haaeA@mail.gmail.com>
Subject: Re: [PATCH 2/2] gpio: mc9s08dz60: Use devm_kzalloc API
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@gmail.com>, Wu Guoxing <b39297@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 29, 2012 at 3:36 AM, Axel Lin <axel.lin@gmail.com> wrote:

> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/gpio/gpio-mc9s08dz60.c |   21 +++------------------
>  1 file changed, 3 insertions(+), 18 deletions(-)

Patch applied to devel.

Freescale folks, if you prefer to take this into your tree tell me
and I'll take it out.

If you want to explicitly ACK all new Freescale patches,
consider updating MAINTAINERS for this driver.

Yours,
Linus Walleij

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932826Ab1LFBaX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 20:30:23 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:52322 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932780Ab1LFBaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 20:30:22 -0500
Message-ID: <4EDD6F84.6070901@solonet.org.ua>
Date: Tue, 06 Dec 2011 03:27:32 +0200
From: Denis Kuzmenko <linux@solonet.org.ua>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20111110 Icedove/3.0.11
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: linux-kernel@vger.kernel.org, Wolfram Sang <w.sang@pengutronix.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH] spi: use gpio_request_one() instead of spi_gpio_alloc()
 helper function
References: <1323071447.20963.3.camel@phoenix>
In-Reply-To: <1323071447.20963.3.camel@phoenix>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2011 09:50 AM, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/spi/spi-gpio.c |   21 ++++-----------------
>  1 files changed, 4 insertions(+), 17 deletions(-)

Acked-by: Denis Kuzmenko <linux@solonet.org.ua>

-- 
Best regards, Denis Kuzmenko.

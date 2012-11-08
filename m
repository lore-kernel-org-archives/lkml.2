Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882Ab2KHHKa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 02:10:30 -0500
Received: from mail.free-electrons.com ([88.190.12.23]:49330 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192Ab2KHHK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 02:10:29 -0500
Date: Thu, 8 Nov 2012 08:10:19 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpio: mvebu: Set free callback for gpio_chip
Message-ID: <20121108081019.4e133962@skate>
In-Reply-To: <1352341649.19098.1.camel@phoenix>
References: <1352341649.19098.1.camel@phoenix>
Organization: Free Electrons
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 08 Nov 2012 10:27:29 +0800, Axel Lin wrote:
> We call pinctrl_request_gpio() in request callback, thus we need to call
> pinctrl_free_gpio() in free callback.
> 
> Both mvebu_gpio_request() and mvebu_gpio_free() are not referenced outside of
> this file, make them static.

Indeed, thanks.

> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Acked-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com

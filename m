Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224Ab1DRFBr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 01:01:47 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:57330 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632Ab1DRFBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 01:01:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Walleij <linus.walleij@stericsson.com>
Subject: Re: [PATCH 2/2] mach-u300: rewrite gpio driver, move to drivers/gpio
Date: Mon, 18 Apr 2011 07:01:30 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jonas Aaberg <jonas.aberg@stericsson.com>
References: <1303076969-13039-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1303076969-13039-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201104180701.30384.arnd@arndb.de>
X-Provags-ID: V02:K0:KJ/Moo4Du9FhXZPTFSzsOq1bwpXTjyTqxDT0H+ZrBxj
 vULCkCuCRMfD5a4Vl0iushrzFC7+2EpaylRLd1dPpS0BxdUlo7
 vM+EPPrd90buIU7wZGzmJW8pnFwOsquvwaEKVzLZIt3y73tzq+
 Y6nweLfdtGk3BBRmdMT36e4nWr0WQOpym3iMUGxUE07cKIp9C7
 p2sp6HNc7BVmaEHmMqKgA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 17 April 2011, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> This rewrites the U300 GPIO driver using gpiolib and the irq_chip
> abstractions, makes it runtime-configured rather than compile-time,
> and moves it to the drivers/gpio subsystem where it belongs,
> depopulating the ARM tree of one more driver.
> 
> Cc: Jonas Aaberg <jonas.aberg@stericsson.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

The new driver looks good, but it would be nice to see the actual changes you did.
You can do that by either passing the -M flag to git-format-patch, or by splitting
up the patch into separate move and rewrite bits, in either order.

Acked-by: Arnd Bergmann <arnd@arndb.de>

	Arnd

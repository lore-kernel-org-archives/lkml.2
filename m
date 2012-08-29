Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623Ab2H2Buk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 21:50:40 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47245 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024Ab2H2BuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 21:50:22 -0400
Message-ID: <1346205016.13176.3.camel@phoenix>
Subject: drivers/gpio/gpio-em.c  build error if CONFIG_GPIO_EM=m
From: Axel Lin <axel.lin@gmail.com>
To: Magnus Damm <damm@opensource.se>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org
Date: Wed, 29 Aug 2012 09:50:16 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Magnus,
I got below build error if CONFIG_GPIO_EM=m

  MODPOST 33 modules
ERROR: "set_irq_flags" [drivers/gpio/gpio-em.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2

Regards,
Axel


